import './widgets/widget.dart';
import 'renderWindow.dart';
import 'dart_codegen.dart';
import 'colour.dart';
import 'getLibrary.dart';

class MainstageApp {
  List<Widget> _widgets = [];
  late cRenderWindow _win;
  late CreateEventSig _initEvent;

  MainstageApp({required String title, required Colour backgroundCol}) {
    final libEvent = getLibrary('Event.c');
    _initEvent = lookupCreateEvent(libEvent);

    _win = initRenderWindow(title, 500, 500, backgroundCol);
  }

  void runApp() {
    final event = cEvent();
    event.structPointer = _initEvent();

    while (SDLEventTypeFromInt(event.GetType()) != SDLEventType.Quit) {
      for (var w in _widgets) {
        w.Draw();
      }
      
      _win.Flush();
      event.Poll();
    }

    event.Destroy();
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
    widget.desktopRenderWindow = _win;
  }
  
  void destroy() {
    _win.Destroy();
  }

}