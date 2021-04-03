import 'widget.dart';
import '../renderWindow.dart';
import '../dart_codegen.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';

import 'dart:io';

import './curves/bezierCurve.dart';
import 'curves/dynamicBezier.dart';

class SplineDrawer extends Widget {
  final int _size = 10;
  final bool _drawIntermediateLines = false;
  
  int _resolution = 0;
  
  List<Point> _points = [];
  Point? _temporaryPoint;
  int? _pointIndexBeingModified;
  
  bool _start = true;
  
  final Colour col;
  
  SplineDrawer({required this.col});

  @override
  void OnMouseDown(int x, int y, MouseButton button) {
    final width = renderer.GetWidth();
    final height = renderer.GetHeight();
    for (var i=0; i<_points.length; i++) {
      final point = _points[i];
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
      _points.add(_temporaryPoint!);
    }
    
    print(_points);
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
      _points[_pointIndexBeingModified!] = newPoint;
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
      } else if (_points.isNotEmpty) {
        _points.removeLast();
      } else {
        _start = true;
      }
    }
  }
  
  @override
  void DrawDesktop(RenderWindow win) {
    setWinColour(win, col);
    final width = win.GetWidth();
    final height = win.GetHeight();
    
    if (_temporaryPoint != null) {
      _points.add(_temporaryPoint!);
    }

    for (var point in _points) {
      win.FillRect(point.getAbsoluteX(width) - (_size ~/ 2), point.getAbsoluteY(height) - (_size ~/ 2), _size, _size);
    }
    
    /*
    for (var i=0; i<_points.length-1; i++) {
      win.DrawLine(_points[i].getAbsoluteX(width), _points[i].getAbsoluteY(height), _points[i+1].getAbsoluteX(width), _points[i+1].getAbsoluteY(height));
    }
    */
    BezierCurve? curve;
    
    if (_points.isNotEmpty) {
      curve = DynamicBezier(_points.toList(), 100);
      curve.showConstructionLines = _drawIntermediateLines;
    }
    
    curve?.renderer = renderer;
    
    curve?.col = col;
    curve?.DrawDesktop(win);
  
    if (_temporaryPoint != null) {
      _points.removeLast();
    }
    
  }
}