import 'dart:io';
import 'dart:ffi' as ffi;
import '../build/codegen/dart_generated.dart';

// expects the name of the C file corresponding to the lib.
ffi.DynamicLibrary getLibrary(String name) {
  String? ext;
  if (Platform.isLinux) {
    ext = 'so';
  } else if (Platform.isMacOS) {
    ext = 'dylib';
  } else if (Platform.isWindows) {
    ext = 'dll';
  }
  
  if (ext == null) {
    throw Exception('getLibrary: Unknown platform');
  }

  final lib_path = '$LIB_DIR/lib${name.substring(0, name.length - 2)}.$ext';
  return ffi.DynamicLibrary.open(lib_path);
}