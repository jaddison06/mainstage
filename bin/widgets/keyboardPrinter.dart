import 'widget.dart';
import '../dart_codegen.dart';

class KeyboardPrinter extends Widget {
  @override
  void OnKeyDown(KeyCode key) {
    print(KeyCodeToString(key));
  }

  @override
  void DrawLinux(cRenderWindow win) {}
}