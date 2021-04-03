import 'bezierCurve.dart';
import '../../renderWindow.dart';
import '../point.dart';
import '../colour.dart';

class CubicBezier extends BezierCurve {
  final Point p1;
  final Point p2;
  final Point p3;
  final Point p4;
  // just init it in the constructor??
  @override
  final int resolution;
  
  CubicBezier(this.p1, this.p2, this.p3, this.p4, this.resolution);

  @override
  void DrawDesktop(RenderWindow win) {
    for (var i = 0; i < resolution; i++) {
      final intermediate_1_1 = interpolate(p1, p2, i);
      final intermediate_1_2 = interpolate(p2, p3, i);
      final intermediate_1_3 = interpolate(p3, p4, i);

      final intermediate_2_1 = interpolate(intermediate_1_1, intermediate_1_2, i);
      final intermediate_2_2 = interpolate(intermediate_1_2, intermediate_1_3, i);

      final result = interpolate(intermediate_2_1, intermediate_2_2, i);

      if (showConstructionLines) {
        setWinColour(win, Colour.black());
        win.DrawPoint(intermediate_1_1.x, intermediate_1_1.y);
        win.DrawPoint(intermediate_1_2.x, intermediate_1_2.y);
        win.DrawPoint(intermediate_1_3.x, intermediate_1_3.y);
        
        win.DrawPoint(intermediate_2_1.x, intermediate_2_1.y);
        win.DrawPoint(intermediate_2_2.x, intermediate_2_2.y);
      }
      
      setWinColour(win, col!);
      win.DrawPoint(result.x, result.y);
    }
  }
}