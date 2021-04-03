class Colour {
  final int r;
  final int g;
  final int b;
  Colour(this.r, this.g, this.b);

  static Colour get red => Colour(255, 0, 0);
  static Colour get green => Colour(0, 255, 0);
  static Colour get blue => Colour(0, 0, 255);
  static Colour get cyan => Colour(255, 0, 255);
  static Colour get yellow => Colour(255, 255, 0);
  static Colour get magenta => Colour(0, 255, 255);
  static Colour get black => Colour(0, 0, 0);
  static Colour get white => Colour(255, 255, 255);
}