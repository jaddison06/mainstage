import 'widget.dart';
import '../renderWindow.dart';
import '../dart_codegen.dart';
import 'point.dart';
import 'colour.dart';
import 'dart:math';

class SplineDrawer extends Widget {
  final int size = 10;

  List<Point> _points = [];
  Point? _temporaryPoint;
  int? _pointIndexBeingModified;

  final Colour col;
  bool _recordPoints = false;
  
  bool _cancelKeyPressed = false;
  bool _mouseIsDown = false;
  
  bool _showTemporary = true;
  
  SplineDrawer({required this.col});
  
  @override
  void OnMouseDown(int x, int y, MouseButton button) {
    if (!_mouseIsDown) {
      final width = renderer.GetWidth();
      final height = renderer.GetHeight();
      for (var i=0; i<_points.length; i++) {
        final point = _points[i];
        if (
          x >= (point.getAbsoluteX(width) - (size ~/ 2)) &&
          y >= (point.getAbsoluteY(height) - (size ~/ 2)) &&
          x <= (point.getAbsoluteX(width) + (size ~/ 2)) &&
          (y <= (point.getAbsoluteY(height) + (size ~/ 2)))
        ) {
          _pointIndexBeingModified = i;
          _temporaryPoint = null;
          return;
        }
      }
      
      if (!_showTemporary) {
        _showTemporary = true;
        if (_points.isEmpty && _temporaryPoint != null) {
          _points.add(_temporaryPoint!);
        }
      } else if (_temporaryPoint != null) {
        if (button == MouseButton.Right) {
          _showTemporary = false;
        } else {
          _points.add(_temporaryPoint!);
        }
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

  @override
  void OnKeyDown(KeyCode key) {
    if (key == KeyCode.Backspace || key == KeyCode.Escape) {
      if (!_cancelKeyPressed) {
        if (_showTemporary) {
          _showTemporary = false;
        } else if (_points.isNotEmpty) {
          _points.removeLast();
        }
      }
      _cancelKeyPressed = true;
    }
  }

  @override
  void OnKeyUp(KeyCode key) {
    if (key == KeyCode.Backspace || key == KeyCode.Escape) {
      _cancelKeyPressed = false;
    }
  }

  @override
  void DrawDesktop(RenderWindow win) {
    // copy-pasted from MousePainter
    // todo (jaddison): mixin?
    setWinColour(win, col);
    final width = win.GetWidth();
    final height = win.GetHeight();
    for (var point in _points) {
      win.FillRect(point.getAbsoluteX(width) - (size ~/ 2), point.getAbsoluteY(height) - (size ~/ 2), size, size);
    }
    for (var i=0; i<_points.length-1; i++) {
      win.DrawLine(_points[i].getAbsoluteX(width), _points[i].getAbsoluteY(height), _points[i+1].getAbsoluteX(width), _points[i+1].getAbsoluteY(height));
    }
    if (_temporaryPoint != null && _showTemporary) {
      // temp point is dynamic anyway - unless the OS resizes the window without the mouse moving, this will be fine
      win.FillRect(_temporaryPoint!.x - (size ~/ 2), _temporaryPoint!.y - (size ~/ 2), size, size);
      if (_points.isNotEmpty) {
        win.DrawLine(_points.last.getAbsoluteX(width), _points.last.getAbsoluteY(height), _temporaryPoint!.x, _temporaryPoint!.y);
      }
    }
  }
}