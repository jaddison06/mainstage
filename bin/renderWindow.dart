import 'dart_codegen.dart';
import 'colour.dart';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';

// todo (jaddison): we should be able to codegen this tbh

cRenderWindow initRenderWindow(
    String title,
    int width,
    int height,
    Colour backgroundCol
) {
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