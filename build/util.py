import os
import os.path as path

C_CODE_DIR = "platform"
LIB_DIR = "build/libs"

def get_all_files_with_extension(dirname, extension):
    # assume we're in the root project dir
    return list(filter(
        lambda fname: path.splitext(fname)[1] == f'.{extension}',
        os.listdir(dirname)
    ))

def get_lines(fname):
    with open(fname, "rt") as fh: return list(map(lambda s: s.strip(), fh.readlines()))