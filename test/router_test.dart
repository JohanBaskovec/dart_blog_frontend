import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockController1 extends Mock implements Controller {}
class MockController2 extends Mock implements Controller {}
class MockRoute extends Mock implements Route {}

void main() {
  group("constructor", () {
    test("should work", () {
      var mockController1 = MockController1();
      var mockController2 = MockController2();

      List<Route> routes = [
        Route("/test1", mockController1),
        Route("/test2", mockController2),
      ];
      var router = Router(routes);
      expect(router.routes, orderedEquals(routes));
    });
  });

  group("getMatchingController", () {
    test("should return that controller that matches a path if there is one", () {
      var requestedPath = "/test";
      var controller = MockController1();
      List<Route> routes = [MockRoute(), MockRoute(), MockRoute()];
      when(routes[0].matches(requestedPath)).thenReturn(false);
      when(routes[1].matches(requestedPath)).thenReturn(true);
      when(routes[1].controller).thenReturn(controller);
      when(routes[2].matches(requestedPath)).thenReturn(false);
      var router = Router(routes);
      var matchingController = router.getMatchingController(requestedPath);
      expect(matchingController, equals(controller));
    });
  });
}
