class Point {
  int x;
  int y;
  final int winX;
  final int winY;

  int getAbsoluteX(int winWidth) {
    final scale = winWidth / winX;
    return (x * scale).toInt();
  }

  int getAbsoluteY(int winHeight) {
    final scale = winHeight / winY;
    return (y * scale).toInt();
  }
  
  Point(this.x, this.y, this.winX, this.winY);
}