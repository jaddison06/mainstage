import 'mainstageApp.dart';
import 'colour.dart';

import 'widgets/centreSquare.dart';
import 'widgets/mousePainter.dart';
import 'widgets/keyboardPrinter.dart';

void main() {
  final app = MainstageApp(
    title: 'Mainstage',
    backgroundCol: Colour(0, 0, 255)
  );
  
  app.addWidget(CentreSquare(
    fillColour: Colour(255, 0, 0),
    size: 50
  ));
  
  app.addWidget(MousePainter(
    col: Colour(255, 255, 0)
  ));

  app.addWidget(KeyboardPrinter());
  
  app.runApp();

  app.destroy();
}