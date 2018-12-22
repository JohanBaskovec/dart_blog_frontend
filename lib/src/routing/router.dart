import 'package:blog_frontend/src/routing/route_holder.dart';

class Router {
  RouteHolder _routeHolder;
  Router(this._routeHolder);

  void routeToHash(String currentHash) {
    var controller = _routeHolder.getMatchingController(currentHash);
    if (controller != null) {
      controller.run();
    } else {
      // TODO: show error
    }
  }
}