class Colour {
  final int r;
  final int g;
  final int b;
  Colour(this.r, this.g, this.b);

  static Colour red() => Colour(255, 0, 0);
  static Colour green() => Colour(0, 255, 0);
  static Colour blue() => Colour(0, 0, 255);
  static Colour cyan() => Colour(255, 0, 255);
  static Colour yellow() => Colour(255, 255, 0);
  static Colour magenta() => Colour(0, 255, 255);
  static Colour black() => Colour(0, 0, 0);
  static Colour white() => Colour(255, 255, 255);
}