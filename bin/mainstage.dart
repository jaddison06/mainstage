import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'libraryTools.dart';
import '../build/shared_enums/dart_enums.dart';

void testRenderWindow() {
  final lib = getLibrary('RenderWindow.c');
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
  
  final window = init('Mainstage'.toNativeUtf8(), 500, 500, 0, 0, 255);
  final code = errorCode(window);
  if (code != 0) {
    print('RenderWindow init failed w/ error code $code');
    destroy(window);
    return;
  }
  
  var event = createEvent();
  var frames = 0;
  while (SDLEventTypeFromInt(getEventType(event)) != SDLEventType.Quit) {
    var pos = frames ~/ 20;
    setColour(window, 255, 255, 0);
    fillRect(window, pos+20, pos+20, 50, 50);
    flush(window);
    
    pollEvent(event);
    frames++;
  }
  destroyEvent(event);
  destroy(window);

}

void main() {
  final lib = getLibrary('Test.c');
  final hello = lookup<Void Function()>(lib, 'Test').asFunction<void Function()>();
  hello();

  testRenderWindow();

}