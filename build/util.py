import os
import os.path as path

C_CODE_DIR = "platform"
LIB_DIR = "build/libs"

def get_all_files_with_extension(dirname, extension):
    
    # get full relative path
    entries = list(map(lambda entry: f"{dirname}/{entry}", os.listdir(dirname)))
    for i in range(len(entries)):
        if path.isdir(entries[i]):
            for entry in get_all_files_with_extension(entries[i], extension):
                entries.append(entry)
    
            
    return list(filter(
        lambda fname: path.splitext(fname)[1] == f'.{extension}',
        entries
    ))

def get_lines(fname):
    with open(fname, "rt") as fh: return list(map(lambda s: s.strip(), fh.readlines()))