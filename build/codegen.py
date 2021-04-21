from util import *
import os.path as path

class Function:
    def __init__(self, name, return_type, params):
        self.name = name
        self.return_type = return_type
        # params should be {"param_name": "param_type"}
        self.params = params
    
    def clone(self):
        return Function(self.name, self.return_type, self.params.copy())
    
    def with_attr(self, k, v):
        new = self.clone()
        new.__setattr__(k, v)
        return new
    
    def __repr__(self):
        out = f"Function: {self.return_type} {self.name}("
        for i, k in enumerate(self.params.keys()):
            out += f"{self.params[k]} {k}"
            if i != len(self.params) - 1: out += ", "
        out += ")"
        return out

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

def generate_dart_funcsig_typedefs(func, prefix=""):
    param_types = func.params.values()
    out = ""
    out += f"\ntypedef _{prefix}{func.name}NativeSig = {get_native_type(func.return_type)} Function("
    # if there aren't any params, we get [''] for some reason
    for i, param in enumerate(param_types):
        out += get_native_type(param)
        if i != len(param_types) -1: out += ', '
    
    out += ");\n"
    out += f"\ntypedef {prefix}{func.name}Sig = {get_dart_type(func.return_type)} Function("
    if param_types != ['']:
        for i, param in enumerate(param_types):
            out += get_dart_type(param)
            if i != len(param_types) - 1: out += ', '
    out += ");\n"

    return out

# TODO: include param names in the .defs file, so we can display them accurately in Dart code.
# maybeeee we could unify .defs & .cclass? (or even .enum??????)
def generate_dart_ffi_utils(lib_name, funcs):
    out = ""

    # typedefs 
    for f in funcs:
        out += generate_dart_funcsig_typedefs(f, "_")
    
    # class header
    out += f"class Lib{lib_name} "
    out += "{\n"
    
    # ffi funcs
    for f in funcs:
        out += f"    late _{f.name}Sig _{f.name};\n"
    out += "\n"
    
    # constructor
    out += f"    Lib{lib_name}() "
    out += "{\n"
    # the fun thing about this is that the lib will only be read off disk once, so we can
    # call the constructor as much as we want w/ relatively little overhead. so instead of
    # passing around a single instance of LibSomething so we can call functions from it, we can
    # just call LibSomething().SomeFunction() wherever it's needed. There's still overhead from function
    # lookup, but overall it's not that bad.
    # https://api.dart.dev/stable/2.10.1/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
    out += f"        final lib = getLibrary('{lib_name}.c');\n\n"
    for f in funcs:
        out += f"        _{f.name} = lib.lookupFunction<__{f.name}NativeSig, _{f.name}Sig>('{f.name}');\n"
    out += "    }\n"
    
    # actual callable funcs
    for f in funcs:
        out += f"    {get_dart_type(f.return_type)} {f.name}("
        for i in range(len(f.param)):
            out += f"{get_dart_type(f.params[i])} arg{i}"
            if i != len(f.params) - 1: out += ", "
        out += ") {\n"
        out += f"        return _{f.name}("
        for i in range(len(f.params)):
            out += f"arg{i}"
            if i != len(f.params) - 1: out += ", "
        out += ");\n"
        out += "    }\n"
    
    
    # close class
    out += "}\n\n"
    
    return out

# todo (jaddison): automatic usage of String instead of Pointer<Utf8> (w/ conversion)

# methods should be array of Functions
def generate_dart_class(class_name, methods, initializer = None):
    out = ""

    # funcsig typedefs
    
    for method in methods:
        # make sure "self" comes first
        params = {'self': 'void*'}
        for k, v in method.params.items():
            params[k] = v
        
        out += generate_dart_funcsig_typedefs(method.with_attr("params", params), f"_class{class_name}")
        out += "\n"
    
    if initializer:
        out += generate_dart_funcsig_typedefs(initializer, "_")
    
    # class boilerplate

    out += f"\n\nclass c{class_name} "
    out += "{\n    Pointer<Void> structPointer = Pointer.fromAddress(0);\n\n"
    out += "    void validatePointer(String methodName) {\n"
    out += "        if (structPointer.address == 0) {\n"
    out += f"            throw Exception('{class_name}.$methodName was called, but structPointer is a nullptr.');\n"
    out += "        }\n    }\n\n"

    # members

    for method in methods:
        # todo (jaddison): does this need to be late?
        out += f"    late _class{class_name}{method.name}Sig _{method.name};\n"
    
    # constructor
    out += f"\n    c{class_name}("
    if initializer:
        for i, k in enumerate(initializer.params.keys()):
            out += f"{get_dart_type(initializer.params[k])} {k}"
            if i != len(initializer.params) - 1: out += ", "
    out += ") "

    out += "{\n"
    out += f"        final lib = getLibrary('{class_name}.c');\n\n"

    for method in methods:
        out += f"        _{method.name} = lib.lookupFunction<__class{class_name}{method.name}NativeSig, _class{class_name}{method.name}Sig>('{method.name}');\n"
    
    if initializer:
        out += f"\n        structPointer = (lib.lookupFunction<__{initializer.name}NativeSig, _{initializer.name}Sig>('{initializer.name}'))("
        for i, k in enumerate(initializer.params.keys()):
            out += k
            if i != len(initializer.params.keys()) - 1: out += ", "
        out += ");\n"

    
    out += "    }\n"

    # methods
    for method in methods:
        out += f"\n     {get_dart_type(method.return_type)} {method.name}("
        for i in range(len(method.params.keys())):
            param_name = list(method.params.keys())[i]
            param_type = method.params[param_name]
            
            out += get_dart_type(param_type)
            out += " "
            out += param_name

            if i != len(method.params.keys())-1: out += ", "
        
        out += ") {\n"
        out += f"        validatePointer('{method.name}');\n"
        out += f"        return _{method.name}(structPointer"
        if len(method.params) != 0: out += ", "
        for i in range(len(method.params.keys())):
            param_name = list(method.params.keys())[i]
            out += param_name
            
            if i != len(method.params.keys())-1: out += ", "
        out += ");\n"
        out += "    }\n"
    
    out += "\n}\n\n"
    
    return out

def get_function(line):
    type_and_name, raw_params = line.split('(')
    raw_params = raw_params[:-1]
    return_type, func_name = type_and_name.split(' ')

    params = {}
    
    param_strings = raw_params.split(',')
    if param_strings != ['']:
        for param in param_strings:
            param_type, param_name = param.strip().split(' ')
            
            # if it's a pointer type, we assume it looks like "int* someParam", not "int *someParam" or "int * someParam"
            params[param_name] = param_type
    
    return Function(func_name, return_type, params)

def generate_dart_ffi_stuff(fname):
    out = ""
    lines = list(map(
        lambda line: line.strip(),
        get_lines(fname)
    ))

    funcs = []
    classes = {} # {"class_name": {"methods": [Function(), Function()], "initializer": Function() or None}}

    current_class_name = ""
    current_metadata = ""
    
    for line in lines:
        if line and not line.isspace() and not line.startswith("//"):
            if "//" in line:
                line = line.split("//")[0]
            
            is_initializer = False
            if line.startswith("@"):
                # yoooo he got metadata n everything !!
                current_metadata = line[1:]
                continue
            
            if (
                line.startswith("class") and 
                current_class_name == "" and
                line.endswith("{")
            ):
                current_class_name = line[5:][:-1].strip()
                continue

            if line == "}":
                current_class_name = ""
                continue
            
            func = get_function(line)
            if current_class_name != "":
                if not current_class_name in classes:
                    classes[current_class_name] = {
                        "methods": [],
                        "initializer": None
                    }
                
                if current_metadata == "initializer":
                    classes[current_class_name]["initializer"] = func
                else:
                    classes[current_class_name]["methods"].append(func)
            else:
                funcs.append(func)
            
            current_metadata = ""
    
    lib_name = path.splitext(path.basename(fname))[0]
    if funcs != []:
        out += generate_decl(f"ffi: static functions for lib{lib_name}")
        out += generate_dart_ffi_utils(lib_name, funcs)
    if classes != {}:
        out += generate_decl(f"ffi: generated classes for lib{lib_name}")
        for c, data in classes.items():
            out += generate_dart_class(c, data["methods"], data["initializer"])
    

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
    
    for fname in get_all_files_with_extension(C_CODE_DIR, "gen"):
        dart_file += generate_dart_ffi_stuff(fname)
    

    with open(C_CODEGEN_FNAME, "wt") as fh: fh.write(c_header)
    with open(DART_CODEGEN_FNAME, "wt") as fh: fh.write(dart_file)


if __name__ == '__main__': main()