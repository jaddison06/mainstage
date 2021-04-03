import 'bezierCurve.dart';
import '../../renderWindow.dart';
import '../point.dart';
import '../colour.dart';

class DynamicBezier extends BezierCurve {
  final List<Point> points;
  
  DynamicBezier(this.points, resolution) {
    // it's on super & idk another way to init it
    this.resolution = resolution;
  }

  @override
  void DrawDesktop(RenderWindow win) {
    var intermediates = points;
    for (var i=0; i<resolution; i++) {
      while (intermediates.length > 1) {
        for (var j=0; j<intermediates.length - 1; j++) {
          final this_point = intermediates[j];
          final next_point = intermediates[j+1];
          if (showConstructionLines) {
            win.DrawLine(this_point.x, this_point.y, next_point.x, next_point.y);
          }

          intermediates[j] = interpolate(this_point, next_point, i);
        }
        intermediates.removeLast();
      }
    }
    setColour(win);
    win.DrawPoint(intermediates.first.x, intermediates.first.y);
  }
}