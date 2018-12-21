import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockController extends Mock implements Controller {}

void main() {
  group("constructor", () {
    test("should work", () {
      var controller = MockController();
      var path = "/test";
      var route = Route(path, controller);
      expect(route.controller, equals(controller));
      expect(route.pathRegexp, equals(RegExp(path)));
    });
  });

  group("matches", () {
    test("should return true when path matches", () {
      var controller = MockController();
      var path = "^/test";
      var route = Route(path, controller);
      var requestedPath = "/test?arg1=value1&arg2=value2";
      var matches = route.matches(requestedPath);
      expect(matches, isTrue);
    });
    test("should return false when path doesn't match", () {
      var controller = MockController();
      var path = r"^/path$";
      var route = Route(path, controller);
      var requestedPath = "/path-longer";
      var matches = route.matches(requestedPath);
      expect(matches, isFalse);
    });
  });
}
