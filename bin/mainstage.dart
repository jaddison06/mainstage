import 'mainstageApp.dart';
import 'colour.dart';
import 'widgets/topBar.dart';
import 'widgets/centreSquare.dart';

void main() {
  final app = MainstageApp(
    title: 'Mainstage',
    backgroundCol: Colour(0, 0, 255)
  );
  
  app.addWidget(TopBar(
    fillColour: Colour(255, 255, 0)
  ));

  app.addWidget(CentreSquare(
    fillColour: Colour(255, 0, 0),
    size: 50
  ));
  
  app.runApp();

  app.destroy();
}