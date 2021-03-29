import '../renderWindow.dart';
import '../mainstagePlatform.dart';
import '../colour.dart';
import '../platformRenderer.dart';
import '../dart_codegen.dart';

class Widget {
  // initialised in MainstageApp.addWidget
  late PlatformRenderer renderer;

  final MainstageTargetPlatform platform = currentPlatform();
  
  void DrawAndroid() {
    throw UnimplementedError('This widget has not been implemented on Android yet.');
  }
  void DrawIOS() {
    throw UnimplementedError('This widget has not been implemented on IOS yet');
  }
  void DrawLinux(RenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on Linux yet');
  }
  void DrawMacOS(RenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on MacOS yet.');
  }
  void DrawWindows(RenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on Windows yet.');
  }
  void DrawWeb() {
    throw UnimplementedError('This widget has not been implemented for the web yet.');
  }
  void DrawTerm() {
    throw UnimplementedError('This widget has not been implemented in the terminal yet.');
  }
  
  // if you want the same behaviour on all platforms you can just override this
  void DrawDesktop(RenderWindow win) {
    switch(platform) {
      case MainstageTargetPlatform.Linux: return DrawLinux(win);
      case MainstageTargetPlatform.MacOS: return DrawMacOS(win);
      case MainstageTargetPlatform.Windows: return DrawWindows(win);
      default: throw Exception('$platform is not a desktop platform!');
    }
  }
  
  void Draw() {
    switch (platform) {
      case MainstageTargetPlatform.Linux:
      case MainstageTargetPlatform.MacOS:
      case MainstageTargetPlatform.Windows:
      return DrawDesktop(renderer.desktop!);

      default: throw UnimplementedError('Mainstage does not currently support rendering on the platform $platform');
    }
  }
  
  void OnMouseMove(int x, int y) {}

  void OnMouseDown(int x, int y, MouseButton button) {}
  void OnMouseUp(int x, int y, MouseButton button) {}
  
  // utility functions
  
  void setWinColour(RenderWindow win, Colour col) {
    win.SetColour(col.r, col.g, col.b);
  }
}