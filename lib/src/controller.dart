import 'package:blog_frontend/src/routing/routing_context.dart';

/// Parent of every controller class of the application.
abstract class Controller {

  /// Loads data and displays an HTML page.
  void run();
}
