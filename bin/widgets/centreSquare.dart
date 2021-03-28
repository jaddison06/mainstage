import 'widget.dart';
import '../dart_codegen.dart';
import '../colour.dart';

class CentreSquare extends Widget {
  final Colour fillColour;
  final int size;

  CentreSquare({required this.fillColour, required this.size});

  @override
  void DrawLinux(cRenderWindow win) {
    setWinColour(win, fillColour);
    win.FillRect(
      (win.GetWidth() ~/ 2) - (size ~/ 2),
      (win.GetHeight() ~/ 2) - (size ~/ 2),
      size,
      size
    );
  }

  // same on all platforms
  @override
  void DrawMacOS(cRenderWindow win) {
    DrawLinux(win);
  }
  
  @override
  void DrawWindows(cRenderWindow win) {
    DrawLinux(win);
  }
}