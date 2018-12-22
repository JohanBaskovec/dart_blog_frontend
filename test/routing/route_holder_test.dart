import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group("getMatchingController", () {
    test(
        "should return the controller "
        "that matches a path if there is one", () {
      var requestedPath = "/test";
      var controller = MockController();
      List<Route> routes = [MockRoute(), MockRoute(), MockRoute()];
      var routeHolder = RouteHolder(routes);
      when(routes[0].matches(requestedPath)).thenReturn(false);
      when(routes[1].matches(requestedPath)).thenReturn(true);
      when(routes[1].controller).thenReturn(controller);
      when(routes[2].matches(requestedPath)).thenReturn(false);
      var matchingController = routeHolder.getMatchingController(requestedPath);
      expect(matchingController, equals(controller));
    });
  });
}
