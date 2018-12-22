import 'package:blog_frontend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';


void main() {
  group("routeToHash", () {
    var routeHolder;
    var controller = MockController();
    setUp(() {
      routeHolder = MockRouteHolder();
      controller = MockController();
    });
    test("should call the controller's run method if hash matches", () {
      var requestedPath = "/test";
      when(routeHolder.getMatchingController(requestedPath))
          .thenReturn(controller);
      var router = Router(routeHolder);
      router.routeToHash("/test");
      verify(controller.run()).called(1);
    });
  });
}
