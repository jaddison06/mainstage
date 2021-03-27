import 'dart:io';

enum MainstageTargetPlatform {
  Android,
  IOS,
  Linux,
  MacOS,
  Windows,
  Web,
  Term
}

// todo (jaddison): Figure out how to build for different platforms
// Detect web
// Detect desktop RenderWindow vs term

MainstageTargetPlatform currentPlatform() {
  if (Platform.isAndroid) { return MainstageTargetPlatform.Android; }
  else if (Platform.isIOS) { return MainstageTargetPlatform.IOS; }
  else if (Platform.isLinux) { return MainstageTargetPlatform.Linux; }
  else if (Platform.isMacOS) { return MainstageTargetPlatform.MacOS; }
  else if (Platform.isWindows) { return MainstageTargetPlatform.Windows; }
  else {
    throw Exception("Mainstage does not currently support checking for the platform '${Platform.operatingSystem}'");
  }
}