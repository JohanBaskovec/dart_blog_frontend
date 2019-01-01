import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';

/// Holds Routes.
class RouteHolder {
  final List<Route> _routes = [];

  /// Create a new RouteHolder.
  RouteHolder();

  /// Get the first Route that matches [requestedPath].
  Controller getMatchingController(String requestedPath) {
    for (Route route in _routes) {
      if (route.matches(requestedPath)) {
        return route.controller;
      }
    }
    return null;
  }

  void addRoute(Route route) {
    _routes.add(route);
  }

  void addRoutes(List<Route> routes) {
    _routes.addAll(routes);
  }
}