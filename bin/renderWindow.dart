import 'dart_codegen.dart';
import 'colour.dart';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';

class RenderWindow extends cRenderWindow {
  RenderWindow(
    String title,
    int width,
    int height,
    Colour backgroundCol
  ) {
    final libRW = getLibrary('RenderWindow.c');
    final init = lookupInitRenderWindow(libRW);
    
    structPointer = init(
      title.toNativeUtf8(),
      width,
      height,
      backgroundCol.r,
      backgroundCol.g,
      backgroundCol.b
    );
  }
}