import 'dart:ffi' as ffi;
import 'getLibrary.dart';

void main() {
  final lib = ffi.DynamicLibrary.open(getLibrary('Test.c'));
  final void Function() hello = lib
    .lookup<ffi.NativeFunction<ffi.Void Function()>>('Test')
    .asFunction();
  hello();
}