import 'dart:convert';

import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/http/http_requester.dart';

/// An HTTP client that converts responses to objects.
class HttpClientImpl implements HttpClient {
  final String _backendUrl;
  final HttpRequester _httpRequester;
  final JsonDecoder _jsonDecoder;

  /// Creates a new JsonClient
  HttpClientImpl(this._backendUrl, this._httpRequester, this._jsonDecoder);

  /// Sends a GET request to [url] and converts the response
  /// to [T] by using [fromJson].
  @override
  Future<T> getObject<T>(
      String url, T fromJson(Map<String, dynamic> json)) async {
    final String response = await _httpRequester.request(_backendUrl + url,
        method: 'GET', responseType: 'json', withCredentials: true);
    final dynamic responseAsJson = _jsonDecoder.convert(response);
    if (responseAsJson is Map<String, dynamic>) {
      return fromJson(responseAsJson);
    } else {
      // TODO: show error
      return Future<T>.error('Wrong JSON received from server, '
          'expected an object, received $response');
    }
  }

  /// Sends a GET request to [url] and converts the response
  /// to a list of T by using [fromJson]. The response by the server
  /// must be a JSON array, and each element of that array must
  /// be convertible to T.
  /// TODO: show error if conversion fails
  @override
  Future<List<T>> getArray<T>(
      String url, T fromJson(Map<String, dynamic> json)) async {
    final String response = await _httpRequester.request(_backendUrl + url,
        method: 'GET', responseType: 'json', withCredentials: true);
    final dynamic responseAsJson = _jsonDecoder.convert(response);
    if (responseAsJson is List<dynamic>) {
      final List<T> list = <T>[];
      for (dynamic o in responseAsJson) {
        if (o is Map<String, dynamic>) {
          list.add(fromJson(o));
        } else {
          // TODO: show error
          return Future<List<T>>.error('Wrong JSON received from server, '
              'expected an object, received $response');
        }
      }
      return list;
    } else {
      // TODO: show error
      return Future<List<T>>.error('Wrong JSON received from server, '
          'expected an array, received $response');
    }
  }
}
