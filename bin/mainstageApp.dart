import 'widgets/widget.dart';
import 'renderWindow.dart';
import 'dart_codegen.dart';
import 'widgets/colour.dart';
import 'getLibrary.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'platformRenderer.dart';

class MainstageApp {
  final List<Widget> _widgets = [];
  late RenderWindow _win;
  late CreateEventSig _initEvent;
  
  Map<KeyCode, bool> _pressedKeys = {};
  Map<MouseButton, bool> _pressedMouseButtons = {};
  
  late Pointer<Int32> _eventPtrX;
  late Pointer<Int32> _eventPtrY;

  MainstageApp({required String title, required Colour backgroundCol, required String fontFile, int fontSize = 18}) {
    final libEvent = getLibrary('Event.c');
    _initEvent = lookupCreateEvent(libEvent);
    
    _win = RenderWindow(title, 500, 500, backgroundCol, fontFile, fontSize);
    
    // event methods that need to return x & y do so by modifying pointers.
    // we alloc these once & use them wherever we need to get an x, y pair.
    // they are NOT guaranteed to keep their values between function calls.
    _eventPtrX = malloc<Int32>();
    _eventPtrY = malloc<Int32>();
    
    for (var key in KeyCode.values) {
      _pressedKeys[key] = false;
    }
    for (var btn in MouseButton.values) {
      _pressedMouseButtons[btn] = false;
    }
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
          
          if (button != MouseButton.Unknown) {
            if (eType == SDLEventType.MouseDown && !_pressedMouseButtons[button]!) {
              for (var widget in _widgets) {
                widget.OnMouseDown(x, y, button);
              }
              _pressedMouseButtons[button] = true;

            } else if (eType == SDLEventType.MouseUp && _pressedMouseButtons[button]!) {
              for (var widget in _widgets) {
                widget.OnMouseUp(x, y, button);
              }
              _pressedMouseButtons[button] = false;
            }
          }
          
          break;
        }
        // todo (jaddison): use keymods to get abs values from system. Pull system keymap & do mods ourself?
        // also impl weird ones like ,.\/|
        case SDLEventType.KeyDown: {
          final key = KeyCodeFromInt(event.GetKeyPressReleaseData());
          if (key == KeyCode.Unknown) { break; }

          // double exclamation marks - ugly! We can assert the KeyCode? because the keys (pun intended) of _pressedKeys
          // are equal to KeyCode.values .
          //
          // the reason for this slight hack is that some keys will fire loads of events for as long as they're held,
          // whereas some will only fire the one event when they're first pressed.
          if (!_pressedKeys[key]!) {
            for (var widget in _widgets) {
              widget.OnKeyDown(key);
            }
            // map lookup is kinda expensive, especially w/ that many keys, so we'll only update the value if it needs it.
            _pressedKeys[key] = true;
          }
          
          break;
        }
        case SDLEventType.KeyUp: {
          final key = KeyCodeFromInt(event.GetKeyPressReleaseData());
          if (key == KeyCode.Unknown) { break; }

          if (_pressedKeys[key]!) {
            for (var widget in _widgets) {
              widget.OnKeyUp(key);
            }
            
            _pressedKeys[key] = false;
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
    destroy();
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