import 'package:blog_frontend/src/routing/route.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group('matches', () {
    test('should return true when path matches', () {
      final MockController controller = MockController();
      const String path = '^/test';
      final Route route = Route(path, controller);
      const String requestedPath = '/test?arg1=value1&arg2=value2';
      final bool matches = route.matches(requestedPath);
      expect(matches, isTrue);
    });
    test("should return false when path doesn't match", () {
      final MockController controller = MockController();
      const String path = r'^/path$';
      final Route route = Route(path, controller);
      const String requestedPath = '/path-longer';
      final bool matches = route.matches(requestedPath);
      expect(matches, isFalse);
    });
  });
  group('==', () {
    test('should return true when routes have same regexp and controller', () {
      const regexp = 'gdkg';
      final controller = MockController();
      final route1 = Route(regexp, controller);
      final route2 = Route(regexp, controller);
      expect(route1 == route2, isTrue);
    });
  });
}
