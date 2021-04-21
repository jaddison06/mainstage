import 'widget.dart';
import '../renderWindow.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';

import 'bezierCurve.dart';

class SplineDrawer extends Widget {
  final bool showConstructionLines;
  final List<Point> _points = [];
  final Colour col;
  
  SplineDrawer({required this.col, required this.showConstructionLines});

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
        // unless i'm mistaken, worst-case is a diagonal, so set that to the resolution (& double it to be safe)
      final resolution = sqrt(pow(renderer.GetWidth(), 2) + pow(renderer.GetHeight(), 2)).toInt() * 1;
      curve = BezierCurve(_points.toList(), resolution, col, showConstructionLines);
    }
    
    if (curve != null) {
      initChild(curve);
    }
    
    curve?.DrawDesktop(win);
    
  }
}