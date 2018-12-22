import 'dart:convert';

import 'package:blog_frontend/src/http_requester.dart';
import 'package:blog_frontend/src/server.dart';

class JsonServer implements Server {
  final String _backendUrl;
  final HttpRequester _httpRequester;
  final JsonDecoder _jsonDecoder;

  JsonServer(this._backendUrl, this._httpRequester, this._jsonDecoder);

  Future<T> get<T>(String url, T fromJson(Map<String, dynamic> json)) async {
    String response = await _httpRequester.request(_backendUrl + url,
        method: "GET", responseType: "json", withCredentials: true);
    return fromJson(_jsonDecoder.convert(response));
  }
}
