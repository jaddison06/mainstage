import 'widget.dart';
import '../renderWindow.dart';
import 'colour.dart';

class Text extends Widget {
  final int x;
  final int y;
  final String text;
  final Colour col;
  
  Text({required this.x, required this.y, required this.text, required this.col});

  @override
  void DrawDesktop(RenderWindow win) {
    win.DrawText(text, x, y, col, 255);
  }

}