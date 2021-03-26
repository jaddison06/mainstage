import '../build/codegen/dart_generated.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'colour.dart';
import 'getLibrary.dart';

class RenderWindow {
  
  // these are blantantly initialized in the constructor. marked them late for now but TODO: get compiler to notice these being initialized

  late Pointer<Void> _win;
  
  late DynamicLibrary _lib;

  late InitRenderWindowSig _init;
  late DestroyRenderWindowSig _destroy;
  late GetErrorCodeSig _errorCode;
  late FlushSig _flush;
  late SetColourSig _setColour;
  late FillRectSig _fillRect;
  late CreateEventSig _createEvent;
  late DestroyEventSig _destroyEvent;
  late PollEventSig _pollEvent;
  late GetEventTypeSig _eventType;
  
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

    _win = _init(title.toNativeUtf8(), width, height, backgroundColour.r, backgroundColour.g, backgroundColour.b);
    final code = PlatformErrorCodeFromInt(_errorCode(_win));
    if (code != PlatformErrorCode.Success) {
      print('RenderWindow init failed with code $code');
      destroy();
    }

  }
  

  void start() {
    // todo (jaddison): If we're really unlucky then event could get alloc'd with a quit value. We shouldn't check until we've polled.
    var event = _createEvent();
    while (SDLEventTypeFromInt(_eventType(event)) != SDLEventType.Quit) {
      var pos = frameCount ~/ 20;
      setColour(Colour(255, 255, 0));
      fillRect(pos + 20, pos + 20, 50, 50);
      flush();

      _pollEvent(event);
      frameCount++;
    }
    _destroyEvent(event);
  }

  void flush() {
    _flush(_win);
  }

  void setColour(Colour col) {
    _setColour(_win, col.r, col.g, col.b);
  }

  void fillRect(int x, int y, int width, int height) {
    _fillRect(_win, x, y, width, height);
  }

  void destroy() {
      _destroy(_win);
  }
}