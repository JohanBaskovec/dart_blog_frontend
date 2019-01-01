import 'package:blog_frontend/src/controller.dart';

/// A route that maps a URL pattern to a Controller.
class Route {
  /// The path pattern.
  final RegExp pathRegexp;

  /// The controller.
  final Controller controller;

  /// Creates a new route that links the [pathRegexp]
  /// to the [controller]'s run method.
  Route(String regexp, this.controller) : pathRegexp = RegExp(regexp);

  /// Checks if a path matches.
  bool matches(String path) {
    return pathRegexp.hasMatch(path);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Route) {
      final equalControllers = controller == other.controller;
      final equalType = runtimeType == other.runtimeType;
      final equalPathRegexp = pathRegexp.pattern == other.pathRegexp.pattern;
      return equalControllers && equalType && equalPathRegexp;
    }
    return false;
  }

  @override
  int get hashCode => pathRegexp.hashCode ^ controller.hashCode;
}
