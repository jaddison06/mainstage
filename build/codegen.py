from util import *
import os.path as path

def get_file(name, ext):
    return get_lines(f"{C_CODE_DIR}/{name}.{ext}")

def generate_dart_enum(name):
    lines = get_file(name, 'enum')
    out = "enum " + name + " {\n"
    for val in lines:
        out += f"    {val},\n"
    out += "}\n\n"
    out += f"{name} {name}FromInt(int val) "
    out += "{\n"
    for i, val in enumerate(lines):
        out += f"    if (val == {i}) "
        out += "{"
        out += f" return {name}.{val}; "
        out += "}\n"
    out += f"    throw Exception('{name} cannot be converted from int $val: Out of range.');\n"
    out += "}\n\n"

    return out

def generate_c_enum(name):
    lines = get_file(name, 'enum')
    out = "enum " + name + " {\n"
    for i, val in enumerate(lines):
        out += f"    {val} = {i},\n"
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

def generate_dart_ffi_utils(defs_file_lines):
    out = f"const LIB_DIR = '{LIB_DIR}';\n\n"
    
    for line in defs_file_lines:
        if not line.isspace():
            return_type_and_name, raw_params = line.split('(')
            return_type, name = return_type_and_name.split(' ')
            params = list(map(
                lambda string: string.strip(),
                raw_params[:-1].split(',')
            ))
            
            out += f"\ntypedef {name}NativeSig = {get_native_type(return_type)} Function("
            # if there aren't any params, we get [''] for some reason
            if params != ['']:
                # if there are multiple params of the same type, they'll all be equal to params[-1], so we have to enumerate.
                for i, param in enumerate(params):
                    out += get_native_type(param)
                    if i != len(params) -1: out += ', '
            out += ");\n"
            out += f"\ntypedef {name}Sig = {get_dart_type(return_type)} Function("
            if params != ['']:
                for i, param in enumerate(params):
                    out += get_dart_type(param)
                    if i != len(params) - 1: out += ', '
            out += ");\n"
            
            out += f"\n{name}Sig lookup{name}(DynamicLibrary lib) "
            out += "{\n"
            out += f"    return lib.lookupFunction<{name}NativeSig, {name}Sig>('{name}');\n"
            out += "}\n\n"
    
    return out
            



            


def generate_decl(name):
    return f"// ----- {name.upper()} -----\n\n"

def main():
    dart_file = "import 'dart:ffi';\nimport 'package:ffi/ffi.dart';\n\n"
    c_header = "#ifndef C_GENERATED_H\n#define C_GENERATED_H\n\n"

    enums_decl =  generate_decl("enums")
    dart_file += enums_decl
    c_header += enums_decl
    
    dart_enums, c_enums = enums()
    dart_file += dart_enums
    c_header += c_enums

    dart_file += generate_decl("ffi utils")
    for f in get_all_files_with_extension(C_CODE_DIR, "defs"):
        name_without_extension = path.splitext(f)[0]
        dart_file += generate_dart_ffi_utils(get_file(name_without_extension, 'defs'))

    c_header += "#endif // C_GENERATED_H"

    with open("build/codegen/c_generated.h", "wt") as fh: fh.write(c_header)
    with open("build/codegen/dart_generated.dart", "wt") as fh: fh.write(dart_file)


if __name__ == '__main__': main()