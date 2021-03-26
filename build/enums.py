from util import *

def get_enum(name):
    return get_lines(f"{C_CODE_DIR}/{name}.enum")

def generate_dart_enum(name):
    lines = get_enum(name)
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
    lines = get_enum(name)
    out = "enum " + name + "{\n"
    for i, val in enumerate(lines):
        out += f"    {val} = {i},\n"
    out += "};\n\n"
    return out

def enums_codegen():
    dart_file = ""
    c_header = \
"""#ifndef ENUMS_H
#define ENUMS_H

"""
    for f in get_all_files_with_extension(C_CODE_DIR, "enum"):
        name_without_extension = path.splitext(f)[0]
        dart_file += generate_dart_enum(name_without_extension)
        c_header += generate_c_enum(name_without_extension)
    c_header += "#endif"
    with open("build/shared_enums/c_enums.h", "wt") as fh: fh.write(c_header)
    with open("build/shared_enums/dart_enums.dart", "wt") as fh: fh.write(dart_file)


if __name__ == '__main__': enums_codegen()