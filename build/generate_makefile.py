import os
import os.path as path
import platform
from util import *

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

def get_meta(line, command):
    if line.startswith(f"// {command}"):
        return line[len(command) +4:]
    else:
        return False

# returns custom libname or "", and list of libs to link against
def parse_meta(lines):
    libname = ""
    libs = []
    for line in lines:
        if get_meta(line, "LIBNAME"):
            libname = line[11:]
        elif get_meta(line, "LINKWITHLIB"):
            libs.append(get_meta(line, "LINKWITHLIB"))
        else: break
    
    return libname, libs

def main():
    makefile = ""
    libnames = []
    
    # individual builds
    for f in get_all_files_with_extension(C_CODE_DIR, "c"):
        libname = path.splitext(path.basename(f))[0]
        with open(f, "rt") as fh:
            meta_libname, link_libs = parse_meta(fh.readlines())
        
        if meta_libname != "": libname = meta_libname

        # todo(jaddison): refactor parse_meta to be slightly nicer & better-commented
        
        libname = f"{LIB_DIR}/lib{libname}.{get_platform_lib_extension()}"
        libnames.append(libname)
        
        #makefile += f"\n{libname}: {f}\n	gcc -shared -o {libname} -fPIC {f}"
        command = f"gcc -shared -o {libname} -I ./platform -fPIC {f}"
        for lib in link_libs:
            command += f" -l{lib.strip()}"
        makefile += generate_makefile_item(libname, [f], [command])
    
    # operations
    makefile += generate_makefile_item("run", ["all"], ["dart run"])
    makefile += generate_makefile_item("clean", [], [f"rm -rf {LIB_DIR}", f"mkdir {LIB_DIR}", f"rm {DART_CODEGEN_FNAME}", f"rm {C_CODEGEN_FNAME}"])
    makefile += generate_makefile_item("makefile", [], ["python3 ./build/generate_makefile.py"])
    makefile += generate_makefile_item("codegen", [], ["python3 ./build/codegen.py"])
    
    # "all" as first target
    all_targets = libnames.copy()
    all_targets.insert(0, "codegen")
    makefile = generate_makefile_item("all", all_targets, []) + makefile
    
    with open("Makefile", "wt") as fh: fh.write(makefile)

if __name__ == '__main__':
    main()