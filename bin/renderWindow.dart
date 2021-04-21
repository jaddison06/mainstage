import 'dart_codegen.dart';
import 'widgets/colour.dart';
import 'package:ffi/ffi.dart';
import 'dart:io';
import 'widgets/point.dart';

class RenderWindow extends cRenderWindow {

  RenderWindow(
    String title,
    int width,
    int height,
    Colour backgroundCol,
    String fontFile,
    int fontSize
  ): super(
    title.toNativeUtf8(),
    width,
    height,
    backgroundCol.r,
    backgroundCol.g,
    backgroundCol.b
  ) {
    
    final rwCode = SDLInitErrorCodeFromInt(GetErrorCode());
    if (rwCode != SDLInitErrorCode.Success) {
      print('SDL init failed with code ${SDLInitErrorCodeToString(rwCode)}');
      Destroy();
      exit(0);
    }
  
  }

  void DrawPoint(Point p) {
    cDrawPoint(p.x, p.y);
  }

  void SetColour(Colour c) {
    cSetColour(c.r, c.g, c.b, 255);
  }
  
  void DrawText(String text, int x, int y, Colour col, [int alpha = 255]) {

  }

}