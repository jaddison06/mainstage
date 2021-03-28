import 'widget.dart';
import '../dart_codegen.dart';
import '../colour.dart';

class TopBar extends Widget {
  final Colour fillColour;
  
  TopBar({required this.fillColour});
  
  @override
  void DrawLinux(cRenderWindow win) {
    setWinColour(win, fillColour);
    win.FillRect(0, 0, win.GetWidth(), 56);
  }
}