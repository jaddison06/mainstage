import 'dart:web_gl';

import '../build/codegen/dart_generated.dart';
import 'dart:ffi';
import 'colour.dart';
import 'getLibrary.dart';

class RenderWindow {
  
  // if it's invalid, use Dart's null, NOT a voidptr
  Pointer<Void>? _win;

  DynamicLibrary _lib;

  InitRenderWindowSig _init;
  DestroyRenderWindowSig _destroy;
  GetErrorCodeSig _errorCode;
  FlushSig _flush;
  SetColourSig _setColour;
  FillRectSig _fillRect;
  CreateEventSig _createEvent;
  DestroyEventSig _destroyEvent;
  PollEventSig _pollEvent;
  GetEventTypeSig _eventType;
  
  int frameCount = 0;
  
  RenderWindow({
    String title = 'Hello, World',
    int width = 500,
    int height = 500,
    required Colour backgroundColour
  }) {
    _lib = getLibrary('RenderWindow.c');
    
    _init = lookupInitRenderWindow(_lib);
    _destroy = lookupDestroyRenderWindow(_lib);
    _errorCode = lookupGetErrorCode(_lib);
    _flush = lookupFlush(_lib);
    _setColour = lookupSetColour(_lib);
    _fillRect = lookupFillRect(_lib);
    _createEvent = lookupCreateEvent(_lib);
    _destroyEvent = lookupDestroyEvent(_lib);
    _pollEvent = lookupPollEvent(_lib);
    _eventType = lookupGetEventType(_lib);

  }
  

  void start() {

  }

  void setColour() {

  }

  void fillRect() {

  }

  void destroy() {

  }
}