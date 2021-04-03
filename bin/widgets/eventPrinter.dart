import 'widget.dart';
import '../dart_codegen.dart';
import '../renderWindow.dart';

class EventPrinter extends Widget {
  @override
  void OnKeyDown(KeyCode key) {
    print(KeyCodeToString(key) + ' down');
  }
  
  @override
  void OnKeyUp(KeyCode key) {
    print(KeyCodeToString(key) + ' up');
  }

  @override
  void OnMouseDown(int x, int y, MouseButton btn) {
    print('${MouseButtonToString(btn)} down @ ($x, $y)');
  }

  @override
  void OnMouseUp(int x, int y, MouseButton btn) {
    print('${MouseButtonToString(btn)} up @ ($x, $y)');
  }
  
  @override
  void DrawDesktop(RenderWindow win) {}
}