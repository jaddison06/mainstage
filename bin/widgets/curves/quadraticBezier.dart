import 'bezierCurve.dart';
import '../../renderWindow.dart';
import '../point.dart';
import '../colour.dart';

class QuadraticBezier extends BezierCurve {
  final Point p1;
  final Point p2;
  final Point p3;
  final int resolutionCoeff;
  
  QuadraticBezier(this.p1, this.p2, this.p3, {required this.resolutionCoeff});

  @override
  void DrawDesktop(RenderWindow win) {
    resolution = getDistance(p1, p3) * resolutionCoeff;
      for (var i=0; i<resolution; i++) {
        final intermediate_1 = interpolate(p1, p2, i);
        final intermediate_2 = interpolate(p2, p3, i);
        final result = interpolate(intermediate_1, intermediate_2, i);
        if (showConstructionLines) {
          setWinColour(win, Colour.red());
          win.DrawPoint(intermediate_1.x, intermediate_1.y);
          setWinColour(win, Colour.green());
          win.DrawPoint(intermediate_2.x, intermediate_2.y);
        }
        setColour(win);
        win.DrawPoint(result.x, result.y);
      }
  }

}