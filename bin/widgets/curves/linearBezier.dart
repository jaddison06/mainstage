import 'bezierCurve.dart';
import '../../renderWindow.dart';
import '../point.dart';

class LinearBezier extends BezierCurve {
  final Point p1;
  final Point p2;
  
  LinearBezier(this.p1, this.p2);
  
  @override
  void DrawDesktop(RenderWindow win) {
    resolution = getDistance(p1, p2);
    setColour(win);
    for (var i=0; i<resolution; i++) {
      final result = interpolate(p1, p2, i);
      win.DrawPoint(result.x, result.y);
    }
  }
}