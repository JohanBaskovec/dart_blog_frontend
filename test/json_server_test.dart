import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/json_server.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks.dart';

class SomeClass {
  String test1;
  String test2;
  static SomeClass fromJson(Map<String, dynamic> json) {
    var ret = SomeClass();
    ret.test1 = json["test1"];
    ret.test2 = json["test2"];
    return ret;
  }
}

void main() {
  group("get", () {
    test("should send a HTTP request and convert the response to an object",
        () async {
      var httpRequester = HttpRequesterMock();
      var jsonDecoder = JsonDecoderMock();
      Map<String, String> json = {
        "test1": "test1-value",
        "test2": "test2-value"
      };
      when(jsonDecoder.convert(any)).thenReturn(json);
      var server = JsonServer("localhost", httpRequester, jsonDecoder);
      var someObject = await server.get<SomeClass>("/test", SomeClass.fromJson);
      expect(someObject.test1, equals("test1-value"));
      expect(someObject.test2, equals("test2-value"));
    });
  });
}
