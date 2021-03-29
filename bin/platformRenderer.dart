import 'renderWindow.dart';
import 'mainstagePlatform.dart';

// possible renderers & some abstracted functions that run on all of them
class PlatformRenderer {
  RenderWindow? desktop;
  final MainstageTargetPlatform platform = currentPlatform();

  PlatformRenderer({this.desktop});

  int GetWidth() {
    switch(platform) {
      case MainstageTargetPlatform.Linux:
      case MainstageTargetPlatform.MacOS:
      case MainstageTargetPlatform.Windows:
      return desktop!.GetWidth();
      
      default: throw UnimplementedError('Cannot get width on platform $platform');
    }
  }
}