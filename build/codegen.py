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

def generate_dart_ffi_utils(defs_file_lines):
    return "\n\n"

def generate_decl(name):
    return f"\n\n// ----- {name.upper()} -----\n\n"

def main():
    dart_file = ""
    c_header = "#ifndef C_GENERATED_H\n#define C_GENERATED_H"

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

    with open("build/shared_enums/c_generated.h", "wt") as fh: fh.write(c_header)
    with open("build/shared_enums/dart_generated.dart", "wt") as fh: fh.write(dart_file)


if __name__ == '__main__': main()