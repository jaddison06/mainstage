import '../point.dart';
import 'dart:math';
import '../widget.dart';
import '../colour.dart';
import 'package:meta/meta.dart';
import '../../renderWindow.dart';

abstract class BezierCurve extends Widget {
  bool showConstructionLines = false;
  Colour? col;
  // you MUST initialize this during Draw...()
  late int resolution;
  
  // Pythagoras
  int getDistance(Point p1, Point p2) {
    final x_diff = (p1.x - p2.x).abs();
    final y_diff = (p1.y - p2.y).abs();
    return (sqrt((pow(x_diff, 2) + pow(y_diff, 2)))).toInt();
  }
  
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
  
  @protected
  void setColour(RenderWindow win) {
    setWinColour(win, col ?? Colour.black());
  }
}