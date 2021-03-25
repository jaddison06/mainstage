import 'dart:io';
import 'dart:ffi' as ffi;

const LIB_DIR = 'build/libs';

// expects the name of the C file corresponding to the lib.
ffi.DynamicLibrary getLibrary(String name) {
  String ext;
  if (Platform.isLinux) {
    ext = 'so';
  } else if (Platform.isMacOS) {
    ext = 'dylib';
  } else if (Platform.isWindows) {
    ext = 'dll';
  }
  final lib_path = '$LIB_DIR/lib${name.substring(0, name.length - 2)}.$ext';
  return ffi.DynamicLibrary.open(lib_path);
}

ffi.Pointer<ffi.NativeFunction<ffiReturnType>> lookup<ffiReturnType extends ffi.NativeType Function()>(ffi.DynamicLibrary lib, String name) {
  return lib.lookup<ffi.NativeFunction<ffiReturnType>>(name);
}