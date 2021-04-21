import 'mainstageApp.dart';
import 'widgets/colour.dart';

import 'widgets/centreSquare.dart';
import 'widgets/mouseSplineDrawer.dart';
import 'widgets/eventPrinter.dart';
import 'widgets/text.dart';

void main() {
  final app = MainstageApp(
    title: 'Test',
    backgroundCol: Colour.blue,
    fontFile: 'res/Menlo-Regular.ttf',
    fontSize: 25
  );
  
  app.addWidget(CentreSquare(
    fillColour: Colour.red,
    size: 50
  ));
  
  app.addWidget(MouseSplineDrawer(
    col: Colour.yellow,
    showConstructionLines: false
  ));

  app.addWidget(Text(x: 30, y: 30, text: 'Penis lol', col: Colour.yellow));
  
  app.addWidget(EventPrinter());
  
  app.runApp();
}