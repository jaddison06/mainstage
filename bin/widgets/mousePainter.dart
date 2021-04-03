import 'widget.dart';
import 'colour.dart';
import '../renderWindow.dart';
import '../dart_codegen.dart';
import 'point.dart';

class MousePainter extends Widget {
  final Colour col;
  final List<Point> _points = [];
  bool _collectPoints = false;

  MousePainter({required this.col});

  @override
  void DrawDesktop(RenderWindow win) {
    setWinColour(win, col);
    final width = win.GetWidth();
    final height = win.GetHeight();
    for (var point in _points) {
      final xScale = width / point.winX;
      final yScale = height / point.winY;
      win.DrawPoint((point.x * xScale).toInt(), (point.y * yScale).toInt());
    }
  }
  
  @override
  void OnMouseMove(int x, int y) {
    if (_collectPoints) {
      _points.add(Point(x, y, renderer.desktop!.GetWidth(), renderer.desktop!.GetHeight()));
    }
  }

  @override
  void OnMouseDown(int x, int y, MouseButton button) {
    if (button == MouseButton.Left) {
      _collectPoints = true;
    }
  }
  
  @override
  void OnMouseUp(int x, int y, MouseButton button) {
    if (button == MouseButton.Left) {
      _collectPoints = false;
    }
  }

}