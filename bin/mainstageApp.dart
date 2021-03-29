import 'widgets/widget.dart';
import 'renderWindow.dart';
import 'dart_codegen.dart';
import 'colour.dart';
import 'getLibrary.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'platformRenderer.dart';

class MainstageApp {
  final List<Widget> _widgets = [];
  late RenderWindow _win;
  late CreateEventSig _initEvent;
  

  late Pointer<Int32> _eventPtrX;
  late Pointer<Int32> _eventPtrY;

  MainstageApp({required String title, required Colour backgroundCol}) {
    final libEvent = getLibrary('Event.c');
    _initEvent = lookupCreateEvent(libEvent);

    _win = RenderWindow(title, 500, 500, backgroundCol);
    
    // event methods that need to return x & y do so by modifying pointers.
    // we alloc these once & use them wherever we need to get an x, y pair.
    // they are NOT guaranteed to keep their values between function calls.
    _eventPtrX = malloc<Int32>();
    _eventPtrY = malloc<Int32>();
  }

  void runApp() {
    final event = cEvent();
    event.structPointer = _initEvent();

    var eType = SDLEventType.NotImplemented; // call it null

    while (eType != SDLEventType.Quit) {
      
      // first event processing, then widget drawing.
      // the recommended event handling method is to parse the event data &
      // store it internally. This way of doing things means that you don't have to
      // wait a frame for the result of your event to be drawn. The downside is that
      // if you do any drawing during the event callback, it's likely to get overwritten
      // by the widget draw.
      
      switch (eType) {
        case SDLEventType.WindowResize: {
          event.GetResizeData(_eventPtrX, _eventPtrY);
          _win.UpdateDimensions(_eventPtrX.value, _eventPtrY.value);

          break;
        }
        case SDLEventType.MouseMove: {
          event.GetMouseMoveData(_eventPtrX, _eventPtrY);
          final x = _eventPtrX.value;
          final y = _eventPtrY.value;
          for (var widget in _widgets) {
            widget.OnMouseMove(x, y);
          }

          break;
        }
        case SDLEventType.MouseDown:
        case SDLEventType.MouseUp: {
          final button = MouseButtonFromInt(event.GetMousePressReleaseData(_eventPtrX, _eventPtrY));
          final x = _eventPtrX.value;
          final y = _eventPtrY.value;
          
          for (var widget in _widgets) {
            if (eType == SDLEventType.MouseDown) {
              widget.OnMouseDown(x, y, button);
            } else {
              widget.OnMouseUp(x, y, button);
            }
          }

          break;
        }
        case SDLEventType.KeyDown:
        case SDLEventType.KeyUp: {
          final key = KeyCodeFromInt(event.GetKeyPressReleaseData());

          for (var widget in _widgets) {
            if (eType == SDLEventType.KeyDown) {
              widget.OnKeyDown(key);
            } else {
              widget.OnKeyUp(key);
            }
          }
          break;
        }
        
        default: {}
      }
      
      for (var w in _widgets) {
        w.Draw();
      }
      
      _win.Flush();
      event.Poll();
      eType = SDLEventTypeFromInt(event.GetType());
    }

    event.Destroy();
  }
  
  void addWidget(Widget widget) {
    _widgets.add(widget);
    widget.renderer = PlatformRenderer(desktop: _win);
  }
  
  void destroy() {
    _win.Destroy();

    malloc.free(_eventPtrX);
    malloc.free(_eventPtrY);
  }

}