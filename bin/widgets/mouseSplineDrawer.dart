import 'widget.dart';
import '../renderWindow.dart';
import '../dart_codegen.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';
import './splineDrawer.dart';

class MouseSplineDrawer extends Widget {
  final int _size = 10;
  late SplineDrawer _drawer;
  
  Point? _temporaryPoint;
  int? _pointIndexBeingModified;
  
  bool _start = true;

  final Colour col;

  MouseSplineDrawer({required this.col, required bool showConstructionLines}) {
    _drawer = SplineDrawer(col: col, showConstructionLines: showConstructionLines);
  }
  
  @override
  void OnMouseDown(int x, int y, MouseButton button) {
    final width = renderer.GetWidth();
    final height = renderer.GetHeight();
    for (var i=0; i<_drawer.points.length; i++) {
      final point = _drawer.points[i];
      if (
        x >= (point.getAbsoluteX(width) - (_size ~/ 2)) &&
        y >= (point.getAbsoluteY(height) - (_size ~/ 2)) &&
        x <= (point.getAbsoluteX(width) + (_size ~/ 2)) &&
        (y <= (point.getAbsoluteY(height) + (_size ~/ 2)))
      ) {
        _pointIndexBeingModified = i;
        _temporaryPoint = null;
        return;
      }
    }
    
    if (_temporaryPoint == null) {
      _temporaryPoint = Point(x, y, renderer.GetWidth(), renderer.GetHeight());
    } else {
      _drawer.addPoint(_temporaryPoint!);
    }
    
  }
  
  @override
  void OnMouseUp(int x, int y, MouseButton button) {
    if (_pointIndexBeingModified != null) {
      _pointIndexBeingModified = null;
    }
  }
  
  @override
  void OnMouseMove(int x, int y) {
    final newPoint = Point(x, y, renderer.GetWidth(), renderer.GetHeight());
    if (_pointIndexBeingModified != null) {
      _drawer.setPoint(_pointIndexBeingModified!, newPoint);
    } else if (_temporaryPoint != null || _start) {
      _temporaryPoint = newPoint;
      _start = false;
    } else {
      _temporaryPoint = null;
    }
  }
  
  // fix weird thing w Widget.renderer being late (line 115)
  @override
  void OnKeyDown(KeyCode key) {
    if (key == KeyCode.Backspace || key == KeyCode.Escape) {
      if (_pointIndexBeingModified != null || _temporaryPoint != null) {
        _temporaryPoint = null;
      } else if (_drawer.points.isNotEmpty) {
        _drawer.removeLastPoint();
      } else {
        _start = true;
      }
    }
  }
  
  @override
  void DrawDesktop(RenderWindow win) {
    final width = win.GetWidth();
    final height = win.GetHeight();
    
    if (_temporaryPoint != null) {
      _drawer.addPoint(_temporaryPoint!);
    }
    
    win.SetColour(col);
    for (var point in _drawer.points) {
      win.FillRect(point.getAbsoluteX(width) - (_size ~/ 2), point.getAbsoluteY(height) - (_size ~/ 2), _size, _size);
    }
    
    initChild(_drawer);
    
    _drawer.DrawDesktop(win);
  
    if (_temporaryPoint != null) {
      _drawer.removeLastPoint();
    }
    
  }
}