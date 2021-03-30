import 'widget.dart';
import '../renderWindow.dart';
import '../dart_codegen.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';

import './curves/bezierCurve.dart';
import './curves/linearBezier.dart';
import './curves/quadraticBezier.dart';

// this actually just draws straight lines. underwhelming, I know
class SplineDrawer extends Widget {
  final int _size = 10;
  final bool _drawIntermediateLines = false;

  BezierCurve? _curve;
  
  int _resolution = 0;

  List<Point> _points = [];
  Point? _temporaryPoint;
  int? _pointIndexBeingModified;

  final Colour col;
  
  bool _mouseIsDown = false;
  
  SplineDrawer({required this.col});
  
  @override
  void OnMouseDown(int x, int y, MouseButton button) {
    if (!_mouseIsDown) {
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
      
      if (_points.length < 3 && _temporaryPoint != null) {
        _points.add(_temporaryPoint!);
      }
    }
    _mouseIsDown = true;
  }
  
  @override
  void OnMouseUp(int x, int y, MouseButton button) {
    if (_pointIndexBeingModified != null) {
      _pointIndexBeingModified = null;
    }
    _mouseIsDown = false;
  }
  
  @override
  void OnMouseMove(int x, int y) {
    final newPoint = Point(x, y, renderer.GetWidth(), renderer.GetHeight());
    if (_pointIndexBeingModified != null) {
      _points[_pointIndexBeingModified!] = newPoint;
    } else {
      _temporaryPoint = newPoint;
    }
  }
  
  // esc/backspace logic feels weird. dk what to do. after this, follow tutorial for cubic bezier. generalize for all polynomials:
  // -> either a phat interpolation/reduce kinda thing
  // -> or split into cubics n shit then render them
  //
  // fix weird thing w Widget.renderer being late (line 115)
  @override
  void OnKeyDown(KeyCode key) {
    if (key == KeyCode.Backspace || key == KeyCode.Escape) {
      if (_pointIndexBeingModified != null) {
        _temporaryPoint = null;
      } else if (_points.isNotEmpty) {
        _points.removeLast();
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
    if (_points.length == 2) {
      _curve = LinearBezier(_points[0], _points[1]);
    } else if (_points.length == 3) {
      _curve = QuadraticBezier(_points[0], _points[1], _points[2], resolutionCoeff: 2);
    }

    _curve?.renderer = renderer;
    
    _curve?.col = col;
    _curve?.DrawDesktop(win);
  
    if (_temporaryPoint != null) {
      _points.removeLast();
    }
    
  }
}