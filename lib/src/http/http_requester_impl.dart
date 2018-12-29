import 'dart:html';

import 'package:blog_frontend/src/http/http_requester.dart';

/// Execute HTTP requests.
class HttpRequesterImpl implements HttpRequester {
  /// Sends a request to [url] and return the response
  /// in the format of [responseType] (if it's 'json', then the returned
  /// object can be any JSON value (array, object...)
  @override
  Future<dynamic> request(String url,
      {String method,
      bool withCredentials,
      String responseType,
      String mimeType,
      Map<String, String> requestHeaders,
      dynamic sendData}) {
    return HttpRequest.request(url,
            method: method,
            withCredentials: withCredentials,
            responseType: responseType,
            mimeType: mimeType,
            requestHeaders: requestHeaders,
            sendData: sendData)
        .then((HttpRequest req) {
      return req.response;
    });
  }
}
