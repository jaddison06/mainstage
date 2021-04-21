import '../renderWindow.dart';
import 'widget.dart';
import 'point.dart';
import 'colour.dart';

class BezierCurve extends Widget {
  final List<Point> points;
  final int resolution;
  final bool showConstructionLines;
  final Colour col;
  
  BezierCurve(this.points, this.resolution, this.col, this.showConstructionLines);
  
  // linear interpolation
  Point interpolate(Point p1, Point p2, int pos) {
    final absoluteWidth = renderer.GetWidth();
    final absoluteHeight = renderer.GetHeight();

    final p1_abs_x = p1.getAbsoluteX(absoluteWidth);
    final p1_abs_y = p1.getAbsoluteY(absoluteHeight);
    final p2_abs_x = p2.getAbsoluteX(absoluteWidth);
    final p2_abs_y = p2.getAbsoluteY(absoluteHeight);
    return Point(
      ((p1_abs_x * (pos / resolution)) + (p2_abs_x * (1 - (pos / resolution)))).toInt(),
      ((p1_abs_y * (pos / resolution)) + (p2_abs_y * (1 - (pos / resolution)))).toInt(),
      absoluteWidth,
      absoluteHeight
    );
  }

  @override
  void DrawDesktop(RenderWindow win) {
    for (var i=0; i<resolution; i++) {
      var intermediates = points.toList();
      //print('Rendering point at interpolation position $i');
      while (intermediates.length > 1) {
        //print('intermediates: $intermediates');
        for (var j=0; j<intermediates.length - 1; j++) {
          final this_point = intermediates[j];
          final next_point = intermediates[j+1];
          //print('this_point: $this_point\nnext_point: $next_point');
          
          // this looks hella weird but I'm pretty sure it's actually working as intended. idk though
          if (showConstructionLines) {
            //setWinColour(win, Colour.black);
            win.DrawLine(this_point.x, this_point.y, next_point.x, next_point.y);
          }

          intermediates[j] = interpolate(this_point, next_point, i);
        }
        intermediates.removeLast();
      }
      win.SetColour(col);
      win.DrawPoint(intermediates.first);
    }
  }
}