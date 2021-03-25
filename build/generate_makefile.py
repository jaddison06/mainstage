import os
import os.path as path
import platform

C_CODE_DIR = "platform"
LIB_DIR = "build/libs"

def get_all_c_files():
    # assume we're in the root project dir
    return list(filter(
        lambda fname: path.splitext(fname)[1] == '.c',
        os.listdir(C_CODE_DIR)
    ))

def get_platform_lib_extension():
    if platform.system() == 'Linux': return 'so'
    elif platform.system() == 'Darwin': return 'dylib'
    elif platform.system() == 'Windows': return 'dll'
    else: raise Exception('Unknown platform')

def generate_makefile_item(target, dependencies, commands):
    out = f"{target}:"
    for dependency in dependencies: out += f" {dependency}"
    for command in commands: out += f"\n	{command}"
    out += "\n\n"
    return out

def main():
    makefile = ""
    libnames = []
    
    # individual builds
    for f in get_all_c_files():
        libname = path.splitext(f)[0]
        with open(f"{C_CODE_DIR}/{f}", "rt") as fh:
            first_line = fh.readlines()[0]
            if first_line.startswith("// LIBNAME"): libname = first_line[11:]
        
        libname = f"{LIB_DIR}/lib{libname}.{get_platform_lib_extension()}"
        libnames.append(libname)
        
        #makefile += f"\n{libname}: {f}\n	gcc -shared -o {libname} -fPIC {f}"
        makefile += generate_makefile_item(libname, [f"{C_CODE_DIR}/{f}"], [f"gcc -shared -o {libname} -fPIC {C_CODE_DIR}/{f}"])
    
    # operations
    makefile += generate_makefile_item("run", ["all"], ["dart run"])
    makefile += generate_makefile_item("clean", [], [F"rm -rf {LIB_DIR}", F"mkdir {LIB_DIR}"])
    makefile += generate_makefile_item("makefile", [], ["python3 ./build/generate_makefile.py"])
    
    # "all" as first target
    makefile = generate_makefile_item("all", libnames, []) + makefile
    
    with open("Makefile", "wt") as fh: fh.write(makefile)

if __name__ == '__main__':
    main()