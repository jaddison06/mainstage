import 'dart_codegen.dart';
import 'widgets/colour.dart';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';
import 'dart:io';

class RenderWindow extends cRenderWindow {

  RenderWindow(
    String title,
    int width,
    int height,
    Colour backgroundCol,
    String fontFile,
    int fontSize
  ) {
    final libRW = getLibrary('RenderWindow.c');
    final initRW = lookupInitRenderWindow(libRW);
    
    structPointer = initRW(
      title.toNativeUtf8(),
      width,
      height,
      backgroundCol.r,
      backgroundCol.g,
      backgroundCol.b
    );
    
    final rwCode = SDLInitErrorCodeFromInt(GetErrorCode());
    if (rwCode != SDLInitErrorCode.Success) {
      print('SDL init failed with code ${SDLInitErrorCodeToString(rwCode)}');
      Destroy();
      exit(0);
    }
  
  }

  void DrawText(String text, int x, int y, Colour col, [int alpha = 255]) {
    print(text);
  }

}