import 'dart:ffi' as ffi;
import 'libraryTools.dart';
import 'dart:io';

void main() {
  final lib = getLibrary('Test.c');
  final void Function() hello = lookup<ffi.Void>(lib, 'Test').asFunction();
  hello();

}