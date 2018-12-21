import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';

class Router {
  List<Route> routes;

  Router(this.routes);

  Controller getMatchingController(String requestedPath) {
    for (var route in routes) {
      if (route.matches(requestedPath)) {
        return route.controller;
      }
    }
    return null;
  }
}