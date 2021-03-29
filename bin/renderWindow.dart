import 'dart_codegen.dart';
import 'widgets/colour.dart';
import 'package:ffi/ffi.dart';
import 'getLibrary.dart';
import 'dart:io';

class RenderWindow extends cRenderWindow {
  late cText _textRenderer;

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
    
    final libText = getLibrary('Text.c');
    final initTTF = lookupInitTextRenderer(libText);
    
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
    
    _textRenderer = cText();
    _textRenderer.structPointer = initTTF(fontFile.toNativeUtf8(), fontSize, GetRenderer());
    final ttfCode = TextInitErrorCodeFromInt(_textRenderer.GetErrorCode());
    if (ttfCode != TextInitErrorCode.Success) {
      print('TTF init failed with code ${TextInitErrorCodeToString(ttfCode)}');
      Destroy();
      exit(0);
    }
  
  }

  void DrawText(String text, int x, int y, Colour col, int alpha) {
    _textRenderer.DrawText(text.toNativeUtf8(), x, y, col.r, col.g, col.b, alpha);
  }
  
  void DestroyTextRenderer() {
    _textRenderer.Destroy();
  }

}