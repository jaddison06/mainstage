import 'widget.dart';
import '../renderWindow.dart';
import 'colour.dart';
import 'square.dart';

class CentreSquare extends Widget {
  late Square _square;
  final int size;

  CentreSquare({required Colour fillColour, required this.size}) {
    _square = Square(
      fillColour: fillColour,
      size: size,
      x: 0, y: 0 // change dynamically later
    );
  }

  @override
  void DrawDesktop(RenderWindow win) {
    _square.x = (win.GetWidth() ~/ 2) - (size ~/ 2);
    _square.y = (win.GetHeight() ~/ 2) - (size ~/ 2);
    _square.DrawDesktop(win);
  }
}