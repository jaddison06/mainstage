import 'widget.dart';
import '../dart_codegen.dart';
import '../colour.dart';

class TopBar extends Widget {
  final Colour fillColour;
  
  TopBar({required this.fillColour});
  
  @override
  void DrawLinux(cRenderWindow win) {
    win.SetColour(fillColour.r, fillColour.g, fillColour.b);
    win.FillRect(0, 0, 69, 56);
  }
}