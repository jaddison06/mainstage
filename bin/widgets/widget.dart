import '../dart_codegen.dart';
import '../mainstagePlatform.dart';

class Widget {
  cRenderWindow? desktopRenderWindow;

  void DrawAndroid() {
    throw UnimplementedError('This widget has not been implemented on Android yet.');
  }
  void DrawIOS() {
    throw UnimplementedError('This widget has not been implemented on IOS yet');
  }
  void DrawLinux(cRenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on Linux yet');
  }
  void DrawMacOS(cRenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on MacOS yet.');
  }
  void DrawWindows(cRenderWindow win) {
    throw UnimplementedError('This widget has not been implemented on Windows yet.');
  }
  void DrawWeb() {
    throw UnimplementedError('This widget has not been implemented for the web yet.');
  }
  void DrawTerm() {
    throw UnimplementedError('This widget has not been implemented in the terminal yet.');
  }
  
  void Draw() {
    final platform = currentPlatform();
    switch (platform) {
      case MainstageTargetPlatform.Linux: return DrawLinux(desktopRenderWindow!);
      case MainstageTargetPlatform.MacOS: return DrawMacOS(desktopRenderWindow!);
      case MainstageTargetPlatform.Windows: return DrawWindows(desktopRenderWindow!);
      default: throw UnimplementedError('Mainstage does not currently support rendering on the platform $platform');
    }
  }
}