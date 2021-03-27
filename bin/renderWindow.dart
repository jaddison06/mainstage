import 'dart_codegen.dart';
import 'colour.dart';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';

// todo (jaddison): we should be able to codegen this tbh

cRenderWindow initRenderWindow({
    required String title,
    required int width,
    required int height,
    required Colour backgroundCol
}) {
  final libRW = getLibrary('RenderWindow.c');
  final init = lookupInitRenderWindow(libRW);

  final win = cRenderWindow();
  win.structPointer = init(
    title.toNativeUtf8(),
    width,
    height,
    backgroundCol.r,
    backgroundCol.g,
    backgroundCol.b
  );
  
  return win;

}