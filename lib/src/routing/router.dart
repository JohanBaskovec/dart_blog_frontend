import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';

/// A Router.
class Router {
  RouteHolder _routeHolder;

  /// Creates a new Router instance.
  Router(this._routeHolder);

  /// Find the first Controller that matches [hash]
  /// in the routes and calls its run method.
  /// Does nothing if no controller matches.
  void routeToHash(String hash) {
    final Controller controller = _routeHolder.getMatchingController(hash);
    if (controller != null) {
      controller.run();
    } else {
      // TODO: show error
    }
  }
}