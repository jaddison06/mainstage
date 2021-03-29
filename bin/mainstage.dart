import 'mainstageApp.dart';
import 'widgets/colour.dart';

import 'widgets/centreSquare.dart';
import 'widgets/splineDrawer.dart';
import 'widgets/keyboardPrinter.dart';
import 'widgets/text.dart';

void main() {
  final app = MainstageApp(
    title: 'Mainstage',
    backgroundCol: Colour(0, 0, 255),
    fontFile: 'res/Menlo-Regular.ttf',
    fontSize: 25
  );
  
  app.addWidget(CentreSquare(
    fillColour: Colour(255, 0, 0),
    size: 50
  ));
  
  app.addWidget(SplineDrawer(
    col: Colour(255, 255, 0)
  ));

  //app.addWidget(Text(x: 30, y: 30, text: 'Penis lol', col: Colour(255, 255, 0)));

  //app.addWidget(KeyboardPrinter());
  
  app.runApp();

  app.destroy();
}