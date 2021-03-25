import 'dart:io';

const LIB_DIR = 'build/libs';

// expects the name of the C file corresponding to the lib.
String getLibrary(String name) {
  String ext;
  if (Platform.isLinux) {
    ext = 'so';
  } else if (Platform.isMacOS) {
    ext = 'dylib';
  } else if (Platform.isWindows) {
    ext = 'dll';
  }
  if (ext == null) {
    return ext;
  } else {
    return '$LIB_DIR/lib${name.substring(0, name.length - 2)}.$ext';
  }
}