import './widgets/widget.dart';
import 'renderWindow.dart';
import 'dart_codegen.dart';
import 'colour.dart';
import 'getLibrary.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class MainstageApp {
  List<Widget> _widgets = [];
  late cRenderWindow _win;
  late CreateEventSig _initEvent;
  
  late Pointer<Int32> _resizePtrWidth;
  late Pointer<Int32> _resizePtrHeight;

  MainstageApp({required String title, required Colour backgroundCol}) {
    final libEvent = getLibrary('Event.c');
    _initEvent = lookupCreateEvent(libEvent);

    _win = initRenderWindow(title, 500, 500, backgroundCol);

    _resizePtrWidth = malloc<Int32>();
    _resizePtrHeight = malloc<Int32>();
  }

  void runApp() {
    final event = cEvent();
    event.structPointer = _initEvent();

    var eType = SDLEventType.NotImplemented; // call it null

    while (eType != SDLEventType.Quit) {
      for (var w in _widgets) {
        w.Draw();
      }

      if (eType == SDLEventType.WindowResize) {
        event.GetResizeData(_resizePtrWidth, _resizePtrHeight);
        _win.UpdateDimensions(_resizePtrWidth.value, _resizePtrHeight.value);
      }
      
      _win.Flush();
      event.Poll();
      eType = SDLEventTypeFromInt(event.GetType());
    }

    event.Destroy();
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
    widget.desktopRenderWindow = _win;
  }
  
  void destroy() {
    _win.Destroy();

    malloc.free(_resizePtrWidth);
    malloc.free(_resizePtrHeight);
  }

}