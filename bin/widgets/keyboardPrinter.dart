import 'widget.dart';
import '../dart_codegen.dart';
import '../renderWindow.dart';

class KeyboardPrinter extends Widget {
  @override
  void OnKeyDown(KeyCode key) {
    print(KeyCodeToString(key));
  }

  @override
  void DrawLinux(RenderWindow win) {}
}