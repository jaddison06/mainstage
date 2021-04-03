import 'widget.dart';
import '../renderWindow.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';

import 'curves/bezierCurve.dart';
import 'curves/dynamicBezier.dart';

class SplineDrawer extends Widget {
  final bool showConstructionLines;
  final List<Point> _points = [];
  final Colour col;

  int resolution;
  
  SplineDrawer({required this.col, required this.showConstructionLines, this.resolution = 100});

  void addPoint(Point point) => _points.add(point);
  void setPoint(int index, Point newPoint) => _points[index] = newPoint;
  void clearPoints() => _points.clear();
  void removeLastPoint() => _points.removeLast();
  // does this do a deep copy, or just return a special reference that
  // can't be mutated? I don't want to be copying all over the place
  List<Point> get points => List.unmodifiable(_points);
  
  @override
  void DrawDesktop(RenderWindow win) {
    BezierCurve? curve;
    
    if (_points.isNotEmpty) {
      curve = DynamicBezier(_points.toList(), resolution);
      curve.showConstructionLines = showConstructionLines;
    }
    
    if (curve != null) {
      initChild(curve);
    }
    
    curve?.col = col;
    curve?.DrawDesktop(win);
    
  }
}