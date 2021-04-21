from util import *
import os.path as path

# todo (jaddison): consistent arg formatting (atm fnames are just being passed around willy nilly)

def get_file(name, ext):
    return get_lines(f"{name}.{ext}")

def generate_dart_enum(name):
    lines = get_file(name, 'enum')
    name = path.basename(name)

    # enum definition
    out = "enum " + name + " {\n"
    for line in lines:
        if line and not line.isspace():
            val = line.split('//')[0].strip()
            out += f"    {val},\n"
    out += "}\n\n"

    # convert from int
    out += f"{name} {name}FromInt(int val) "
    out += "{\n"
    for i, line in enumerate(lines):
        if line and not line.isspace():
            val = line.split('//')[0].strip()
            out += f"    if (val == {i}) "
            out += "{"
            out += f" return {name}.{val}; "
            out += "}\n"
    out += f"    throw Exception('{name} cannot be converted from int $val: Out of range.');\n"
    out += "}\n\n"
    
    # convert to string
    out += f"String {name}ToString({name} val) "
    out += "{\n"
    for line in lines:
        if line and not line.isspace():
            if "//" in line:
                # custom string
                val, repr = line.split('//')
                out += f"    if (val == {name}.{val.strip()}) "
                out += "{"
                out += f" return '{repr.strip()}'; "
                out += "}\n"
            else:
                val = line.strip()
                out += f"    if (val == {name}.{val}) "
                out += "{"
                out += f" return '{val}'; "
                out += "}\n"
    out += "    // to please the compiler - a human would use a switch statement\n    return '';\n"
    out += "}\n\n"


    return out

def generate_c_enum(name):
    lines = get_file(name, 'enum')
    name = path.basename(name)
    out = "enum " + name + " {\n"
    for i, line in enumerate(lines):
        if line and not line.isspace():
            val = line.split('//')[0].strip()
            out += f"    {name}_{val} = {i},\n"
    out += "};\n\n"
    return out

def enums():
    dart = ""
    c = ""
    for f in get_all_files_with_extension(C_CODE_DIR, "enum"):
        name_without_extension = path.splitext(f)[0]
        dart += generate_dart_enum(name_without_extension)
        c += generate_c_enum(name_without_extension)
    
    return dart, c

# todo (jaddison): refactor ffigen to a slightly nicer layout

# todo (jaddison): enum C return types w/ automatic conversion

def get_native_type(type):
    out = ""

    is_pointer = type[-1] == "*"
    if is_pointer: type = type[:-1]

    if type == "void": out = "Void"
    elif type == "char": out = "Utf8"
    elif type == "int": out = "Int32"
    else: raise Exception(f"Cannot convert {type} to an FFI native type")

    if is_pointer: out = f"Pointer<{out}>"
    return out

def get_dart_type(type):
    out = ""

    is_pointer = type[-1] == "*"
    # can't have pointers to Dart types - eg a voidptr needs to be Pointer<Void> (capital V)
    if is_pointer: return get_native_type(type)
    
    if type == "void": out = "void"
    elif type == "char": out = "Utf8"
    elif type == "int": out = "int"
    else: raise Exception(f"Cannot convert {type} to a Dart type")

    if is_pointer: out = f"Pointer<{out}>"
    return out

def generate_dart_funcsig_typedefs(name, return_type, params, prefix=""):
    out = ""
    out += f"\ntypedef _{prefix}{name}NativeSig = {get_native_type(return_type)} Function("
    # if there aren't any params, we get [''] for some reason
    if params != ['']:
        # if there are multiple params of the same type, they'll all be equal to params[-1], so we have to enumerate.
        for i, param in enumerate(params):
            out += get_native_type(param)
            if i != len(params) -1: out += ', '
    out += ");\n"
    out += f"\ntypedef {prefix}{name}Sig = {get_dart_type(return_type)} Function("
    if params != ['']:
        for i, param in enumerate(params):
            out += get_dart_type(param)
            if i != len(params) - 1: out += ', '
    out += ");\n"

    return out

# TODO: include param names in the .defs file, so we can display them accurately in Dart code.
# maybeeee we could unify .defs & .cclass? (or even .enum??????)
def generate_dart_ffi_utils(class_name, defs_file_lines):
    funcs = {}
    out = ""
    for line in defs_file_lines:
        if line and not line.isspace():
            return_type_and_name, raw_params = line.split('(')
            return_type, name = return_type_and_name.split(' ')
            params = list(map(
                lambda string: string.strip(),
                raw_params[:-1].split(',')
            ))
            funcs[name] = {
                "return_type": return_type,
                "params": params
            }

            # legacy way of doing things. Now we use classes to represent libs.           
            '''out += f"\n{name}Sig lookup{name}(DynamicLibrary lib) "
            out += "{\n"
            out += f"    return lib.lookupFunction<_{name}NativeSig, {name}Sig>('{name}');\n"
            out += "}\n\n"
            '''
            
    # typedefs 
    for f, data in funcs.items():
        out += generate_dart_funcsig_typedefs(f, data["return_type"], data["params"], "_")
    
    # class header
    out += f"class Lib{class_name} "
    out += "{\n"
    
    # ffi funcs
    for f, data in funcs.items():
        out += f"    late _{f}Sig _{f};\n"
    out += "\n"
    
    # constructor
    out += f"    Lib{class_name}() "
    out += "{\n"
    # the fun thing about this is that the lib will only be read off disk once, so we can
    # call the constructor as much as we want w/ relatively little overhead. so instead of
    # passing around a single instance of LibSomething so we can call functions from it, we can
    # just call LibSomething().SomeFunction() wherever it's needed. There's still overhead from function
    # lookup, but overall it's not that bad.
    # https://api.dart.dev/stable/2.10.1/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
    out += f"        final lib = getLibrary('{class_name}.c');\n\n"
    for f, data in funcs.items():
        out += f"        _{f} = lib.lookupFunction<__{f}NativeSig, _{f}Sig>('{f}');\n"
    out += "    }\n"

    # actual callable funcs
    for f, data in funcs.items():
        out += f"    {get_dart_type(data['return_type'])} {f}("
        if data['params'] != ['']: # what the fuck
            for i in range(len(data["params"])):
                out += f"{get_dart_type(data['params'][i])} arg{i}"
                if i != len(data["params"]) - 1: out += ", "
        out += ") {\n"
        out += f"        return _{f}("
        # lmao abstraction who?
        if data['params'] != ['']: # what the fuck
            for i in range(len(data["params"])):
                out += f"arg{i}"
                if i != len(data["params"]) - 1: out += ", "
        out += ");\n"
        out += "    }\n"
    
    
    # close class
    out += "}\n\n"

    return out


# output should look like this:
# typedef _cClassClassNameMethodNameNativeSig Void Function(Pointer<Void>, int)
# typedef _cClassClassNameMethodNameSig void Function(Pointer<Void>, int)
#
# class ClassName {
#   Pointer<Void> structPointer;
#
#   void validatePointer(String methodName) {
#       if (structPointer.address == 0) {
#           throw Exception('ClassName.$methodName was called, but structPointer is a nullptr.');
#       }
#   }
#
#   late _cClassClassNameMethodNameSig _MethodName;
#
#   ClassName() {
#       lib = getLibrary(CFileName);
#       _methodName = lib.lookupFunction<_cClassClassNameMethodNameNativeSig, _cClassClassNameMethodNmeSig>(MethodName);
#   }
#
#   
#   MethodReturnType MethodName(args...) {
#       validatePointer(MethodName);
#       _MethodName(structPointer, args...);
#   }
#
# }
def generate_dart_class(cclass_file_path):
    full_name, ext = path.splitext(cclass_file_path)
    ext = ext[1:]
    class_name = "c" + path.basename(full_name)
    lines = get_file(full_name, ext)
    
    c_fname = class_name[1:] + ".c"
    
    out = ""

    methods = {}
    
    for line in lines:
        if line and not line.isspace():
            type_and_name, raw_params = line.split('(')
            raw_params = raw_params[:-1]
            type, method_name = type_and_name.split(' ')
            
            methods[method_name] = {
                "return_type": type,
                "params": {}
            }
            
            params = raw_params.split(',')
            if params != ['']:
                for param in params:
                    param_type, param_name = param.strip().split(' ')
                    
                    # if it's a pointer type, we assume it looks like "int* someParam", not "int *someParam" or "int * someParam"
                    methods[method_name]["params"][param_name] = param_type

    # funcsig typedefs

    for method_name, data in methods.items():
        param_types = ['void*'] + [param_type for param_type in data["params"].values()]
        out += generate_dart_funcsig_typedefs(method_name, data["return_type"], param_types, f"_class{class_name}")
        out += "\n"
    
    # class boilerplate

    out += f"\n\nclass {class_name} "
    out += "{\n    Pointer<Void> structPointer = Pointer.fromAddress(0);\n\n"
    out += "    void validatePointer(String methodName) {\n"
    out += "        if (structPointer.address == 0) {\n"
    out += f"            throw Exception('{class_name}.$methodName was called, but structPointer is a nullptr.');\n"
    out += "        }\n    }\n\n"

    # members

    for method_name in methods:
        # todo (jaddison): does this need to be late?
        out += f"    late _class{class_name}{method_name}Sig _{method_name};\n"
    
    # constructor
    out += f"\n    {class_name}() "
    out += "{\n"
    out += f"        final lib = getLibrary('{c_fname}');\n\n"

    for method_name in methods:
        out += f"        _{method_name} = lib.lookupFunction<__class{class_name}{method_name}NativeSig, _class{class_name}{method_name}Sig>('{method_name}');\n"
    
    out += "    }\n"

    # methods
    for method_name, data in methods.items():
        out += f"\n     {get_dart_type(data['return_type'])} {method_name}("
        for i in range(len(data["params"].keys())):
            param_name = list(data["params"].keys())[i]
            param_type = data["params"][param_name]
            
            out += get_dart_type(param_type)
            out += " "
            out += param_name

            if i != len(data["params"].keys())-1: out += ", "
        
        out += ") {\n"
        out += f"        validatePointer('{method_name}');\n"
        out += f"        return _{method_name}(structPointer"
        if len(data["params"]) != 0: out += ", "
        for i in range(len(data["params"].keys())):
            param_name = list(data["params"].keys())[i]
            out += param_name

            if i != len(data["params"].keys())-1: out += ", "
        out += ");\n"
        out += "    }\n"
    
    out += "\n}\n\n"
    
    return out



def generate_decl(name):
    return f"// ----- {name.upper()} -----\n\n"

def main():
    dart_file = f"import 'dart:ffi';\nimport 'package:ffi/ffi.dart';\nimport 'getLibrary.dart';\n\nconst LIB_DIR = '{LIB_DIR}';\n\n"
    c_header = "#ifndef C_CODEGEN_H\n#define C_CODEGEN_H\n\n"

    enums_decl =  generate_decl("enums")
    dart_file += enums_decl
    c_header += enums_decl
    
    dart_enums, c_enums = enums()
    dart_file += dart_enums
    c_header += c_enums
    
    c_header += "#endif // C_CODEGEN_H"

    dart_file += generate_decl("ffi: generated classes for C function libraries")
    for f in get_all_files_with_extension(C_CODE_DIR, "defs"):
        name_without_extension = path.splitext(f)[0]
        dart_file += generate_dart_ffi_utils(path.basename(name_without_extension), get_file(name_without_extension, 'defs'))
    
    dart_file += generate_decl("ffi: generated classes for C structs")
    for f in get_all_files_with_extension(C_CODE_DIR, "cclass"):
        dart_file += generate_dart_class(f)
    

    with open(C_CODEGEN_FNAME, "wt") as fh: fh.write(c_header)
    with open(DART_CODEGEN_FNAME, "wt") as fh: fh.write(dart_file)


if __name__ == '__main__': main()