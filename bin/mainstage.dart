import 'dart:ffi';
import 'libraryTools.dart';
import 'dart:io';
import '../build/shared_enums/dart_enums.dart';

void testRenderWindow() {
  final lib = getLibrary('RenderWindow.c');
  final init = lib.lookupFunction<Pointer<Void> Function(Int32, Int32, Int32, Int32, Int32), Pointer<Void> Function(int, int, int, int, int)>('InitRenderWindow');
  final destroy = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('DestroyRenderWindow');
  final errorCode = lib.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('GetErrorCode');
  final flush = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('Flush');
  final setColour = lib.lookupFunction<Void Function(Pointer<Void>, Int32, Int32, Int32), void Function(Pointer<Void>, int, int, int)>('SetColour');
  final fillRect = lib.lookupFunction<Void Function(Pointer<Void>, Int32, Int32, Int32, Int32), void Function(Pointer<Void>, int, int, int, int)>('FillRect');
  final createEvent = lib.lookupFunction<Pointer<Void> Function(), Pointer<Void> Function()>('CreateEvent');
  final destroyEvent = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('DestroyEvent');
  final pollEvent = lib.lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>('PollEvent');
  final getEventType = lib.lookupFunction<Int32 Function(Pointer<Void>), int Function(Pointer<Void>)>('GetEventType');
  
  final window = init(500, 500, 0, 0, 255);
  final code = errorCode(window);
  if (code != 0) {
    print('RenderWindow init failed w/ error code $code');
    destroy(window);
    return;
  }
  
  var event = createEvent();
  while (SDLEventTypeFromInt(getEventType(event)) != SDLEventType.Quit) {
    setColour(window, 255, 255, 0);
    fillRect(window, 20, 20, 50, 50);
    flush(window);
    
    pollEvent(event);
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