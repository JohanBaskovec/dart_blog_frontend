
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  MockRouteHolder routeHolder;
  MockController controller = MockController();
  Router router;
  setUp(() {
    routeHolder = MockRouteHolder();
    controller = MockController();
    router = Router.create(routeHolder);
  });
  group('routeToHash', () {
    test("should call the controller's run method if hash matches", () {
      const String requestedPath = '/test';
      when(routeHolder.getMatchingController(requestedPath))
          .thenReturn(controller);
      router.routeToHash('/test');
      verify(controller.run()).called(1);
    });
  });
  group('addController', () {
    test('should add a controller', () {
      final controller = MockController();
      const hash = 'test-hash';
      when(controller.hash).thenReturn(hash);
      router.addController(controller);
      verify(routeHolder.addRoute(Route(hash, controller)));
    });
  });
}
