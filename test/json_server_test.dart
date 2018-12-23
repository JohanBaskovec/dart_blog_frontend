import 'package:blog_frontend/src/http_client_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks.dart';

class SomeClass {
  String test1;
  String test2;

  static SomeClass fromJson(Map<String, dynamic> json) {
    final SomeClass ret = SomeClass();
    // ignore: avoid_as
    ret.test1 = json['test1'] as String;
    // ignore: avoid_as
    ret.test2 = json['test2'] as String;
    return ret;
  }
}

void main() {
  group('get', () {
    test('should send a HTTP request and convert the response to an object',
        () async {
      final HttpRequesterMock httpRequester = HttpRequesterMock();
      final JsonDecoderMock jsonDecoder = JsonDecoderMock();
      final Map<String, Object> json = <String, Object>{
        'test1': 'test1-value',
        'test2': 'test2-value'
      };
      when(jsonDecoder.convert(any)).thenReturn(json);
      final HttpClientImpl server =
          HttpClientImpl('localhost', httpRequester, jsonDecoder);
      final SomeClass someObject =
          await server.getObject<SomeClass>('/test', SomeClass.fromJson);
      expect(someObject.test1, equals('test1-value'));
      expect(someObject.test2, equals('test2-value'));
    });
  });
}
