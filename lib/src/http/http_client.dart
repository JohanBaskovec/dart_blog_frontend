import 'dart:convert';

import 'package:blog_frontend/src/http/http_requester.dart';

/// An HTTP client that converts responses to objects.
class HttpClient {
  final String _backendUrl;
  final HttpRequester _httpRequester;

  /// Creates a new JsonClient
  HttpClient(this._backendUrl, this._httpRequester);

  /// Sends a GET request to [url] and converts the response
  /// to [T] by using [fromJson].
  Future<T> getObject<T>(String url, T fromJson(Map json)) async {
    final dynamic response = await _httpRequester.request(_backendUrl + url,
        method: 'GET', responseType: 'json', withCredentials: true);
    assert(
        response is Map,
        'HttpClientImpl.getObject expected to '
        'receive a JSON map from the backend, but received $response');
    return fromJson(response as Map);
  }

  /// Sends a GET request to [url] and converts the response
  /// to a list of T by using [fromJson]. The response by the server
  /// must be a JSON array, and each element of that array must
  /// be convertible to T.
  Future<List<T>> getArray<T>(String url, T fromJson(Map json)) async {
    final dynamic response = await _httpRequester.request(_backendUrl + url,
        method: 'GET', responseType: 'json', withCredentials: true);
    assert(
        response is List,
        'HttpClientImpl.getArray expected to '
        'receive a JSON array from the backend, but received $response');
    final List<T> list = <T>[];
    for (dynamic o in response) {
      assert(
          o is Map,
          'HttpClientImpl.getArray expected each element '
          'in the JSON array to be a JSON map, but received $response');
      list.add(fromJson(o as Map));
    }
    return list;
  }

  /// Converts [data] to a JSON string,
  /// sends it to [path] and converts the response
  /// to [U] using [fromJson]
  Future<U> post<T, U>(
      String path, T data, [U fromJson(Map json)]) async {
    final dynamic response = _httpRequester.request(_backendUrl + path,
        method: 'POST',
        responseType: 'json',
        mimeType: 'application/json',
        sendData: jsonEncode(data));
    if (fromJson != null) {
      return fromJson(response as Map);
    } else {
      return null;
    }
  }
}
