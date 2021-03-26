import '../build/shared_enums/dart_enums.dart';
import 'cClass.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'colour.dart';

class RenderWindow extends cClass {
  
  // if it's invalid, use Dart's null, NOT a voidptr
  Pointer<Void>? win;
  
  int frameCount = 0;
  
  RenderWindow({
    String title = "Hello, World",
    int width = 500,
    int height = 500,
    required Colour backgroundColour
  }) : super('RenderWindow.c', [
    FuncSignature(
      Pointer<Void> Function(Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32),
      Pointer<Void> Function(Pointer<Utf8>, int, int, int, int, int),
      'InitRenderWindow'
    ),
    FuncSignature(
      Void Function(Pointer<Void>),
      void Function(Pointer<Void>),
      'DestroyRenderWindow'
    ),
    FuncSignature(
      Int32 Function(Pointer<Void>),
      int Function(Pointer<Void>),
      'GetErrorCode'
    ),
    FuncSignature(
      Void Function(Pointer<Void>),
      void Function(Pointer<Void>),
      'Flush'
    ),
    FuncSignature(
      Void Function(Pointer<Void>, Int32, Int32, Int32),
      void Function(Pointer<Void>, int, int, int),
      'SetColour'
    ),
    FuncSignature(
      Void Function(Pointer<Void>, Int32, Int32, Int32, Int32),
      void Function(Pointer<Void>, int, int, int, int),
      'FillRect'
    ),
    FuncSignature(
      Pointer<Void> Function(),
      Pointer<Void> Function(),
      'CreateEvent'
    ),
    FuncSignature(
      Void Function(Pointer<Void>),
      void Function(Pointer<Void>),
      'DestroyEvent'
    ),
    FuncSignature(
      Void Function(Pointer<Void>),
      void Function(Pointer<Void>),
      'PollEvent'
    ),
    FuncSignature(
      Int32 Function(Pointer<Void>),
      int Function(Pointer<Void>),
      'GetEventType'
    )
  ]) {/*
    lib = getLibrary('RenderWindow.c');
      
    final init = lib.lookupFunction<Pointer<Void> Function(Pointer<Utf8>, Int32, Int32, Int32, Int32, Int32), Pointer<Void> Function(Pointer<Utf8>, int, int, int, int, int)>('InitRenderWindow');
    final destroy = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('DestroyRenderWindow');
    final errorCode = lib.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('GetErrorCode');
    final flush = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('Flush');
    final setColour = lib.lookupFunction<Void Function(Pointer<Void>, Int32, Int32, Int32), void Function(Pointer<Void>, int, int, int)>('SetColour');
    final fillRect = lib.lookupFunction<Void Function(Pointer<Void>, Int32, Int32, Int32, Int32), void Function(Pointer<Void>, int, int, int, int)>('FillRect');
    final createEvent = lib.lookupFunction<Pointer<Void> Function(), Pointer<Void> Function()>('CreateEvent');
    final destroyEvent = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('DestroyEvent');
    final pollEvent = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('PollEvent');
    final getEventType = lib.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('GetEventType');
    */

    win = funcs['InitRenderWindow'](title.toNativeUtf8(), width, height, backgroundColour.r, backgroundColour.g, backgroundColour.b);
    final code = PlatformErrorCodeFromInt(funcs['GetErrorCode'](win));
    if (code != PlatformErrorCode.Success) {
      print('RenderWindow init failed w/ error code $code');
      destroy();
      return;
    }
  }

  void setColour(Colour col) {
    funcs['SetColour'](win, col.r, col.g, col.b);
  }

  void start() {
    var event = funcs['CreateEvent']();
    // todo (jaddison): If we're really unlucky then event could get alloc'd with a quit value. We shouldn't check until we've polled.
    while (SDLEventTypeFromInt(funcs['GetEventType'](event)) != SDLEventType.Quit) {
      var pos = frameCount ~/ 20;
      setColour(Colour(255, 255, 0));
      funcs['FillRect'](win, pos + 20, pos + 20, 50, 50);
      funcs['Flush'](win);

      funcs['PollEvent'](event);
      frameCount++;
    }
    funcs['DestroyEvent'](event);
  }

  void destroy() {
    funcs['DestroyRenderWindow'](win);
    win = null;
  }
}