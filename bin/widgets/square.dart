import 'widget.dart';
import '../renderWindow.dart';
import '../colour.dart';

class Square extends Widget {
  Colour fillColour;
  int size;
  int x, y;
  
  Square({required this.fillColour, required this.x, required this.y, required this.size});

  @override
  void DrawDesktop(RenderWindow win) {
    setWinColour(win, fillColour);
    win.FillRect(x, y, size, size);
  }
}