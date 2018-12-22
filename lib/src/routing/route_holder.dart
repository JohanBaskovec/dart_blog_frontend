import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';

class RouteHolder {
  List<Route> _routes;

  RouteHolder(this._routes);

  Controller getMatchingController(String requestedPath) {
    for (var route in _routes) {
      if (route.matches(requestedPath)) {
        return route.controller;
      }
    }
    return null;
  }
}