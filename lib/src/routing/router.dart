import 'dart:html';

import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';

/// A Router.
class Router {
  final RouteHolder _routeHolder;
  Controller _currentController;

  /// Creates a new Router instance.
  Router.create(this._routeHolder);

  Router.createDefault() : _routeHolder = RouteHolder();

  /// Find the first Controller that matches [hash]
  /// in the routes and calls its run method.
  /// Does nothing if no controller matches.
  void routeToHash(String hash) {
    //We replace the first
    final Controller controller =
        _routeHolder.getMatchingController(hash.replaceFirst('#', ''));
    if (_currentController != null) {
      _currentController.onLeave();
    }
    _currentController = controller;
    if (controller != null) {
      controller.run();
    } else {
      // TODO: show error
    }
  }

  void startRouting() {
    window.onHashChange.listen((Event event) {
      routeToHash(window.location.hash);
    });
    routeToHash(window.location.hash);
  }

  void addController(Controller controller) {
    _routeHolder.addRoute(Route(controller.hash, controller));
  }
}
