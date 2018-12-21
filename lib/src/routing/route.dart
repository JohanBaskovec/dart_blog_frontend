import 'package:blog_frontend/src/controller.dart';

class Route {
  final RegExp pathRegexp;
  final Controller controller;

  /// Creates a new route that links the [pathRegexp] to the [controller]'s run method.
  Route(String regexp, Controller controller)
      : pathRegexp = RegExp(regexp),
        this.controller = controller {}

  bool matches(String path) {
    return pathRegexp.hasMatch(path);
  }
}
