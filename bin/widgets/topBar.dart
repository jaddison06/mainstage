import 'widget.dart';
import '../renderWindow.dart';
import 'colour.dart';

class TopBar extends Widget {
  final Colour fillColour;
  
  TopBar({required this.fillColour});
  
  @override
  void DrawLinux(RenderWindow win) {
    win.SetColour(fillColour);
    win.FillRect(0, 0, win.GetWidth(), 56);
  }
}