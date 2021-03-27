import 'widgets/topBar.dart';
import 'mainstageApp.dart';
import 'colour.dart';

void main() {
  final app = MainstageApp(
    title: 'Mainstage',
    backgroundCol: Colour(0, 0, 255)
  );
  
  app.addWidget(TopBar(
    fillColour: Colour(255, 255, 0)
  ));

  app.runApp();

  app.destroy();
}