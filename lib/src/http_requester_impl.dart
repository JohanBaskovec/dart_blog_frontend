import 'dart:html';

import 'package:blog_frontend/src/http_requester.dart';

/// Execute HTTP requests.
class HttpRequesterImpl implements HttpRequester {
  /// Sends a request to [url]
  @override
  Future<String> request(String url,
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
        sendData: sendData).then((HttpRequest req) => req.responseText );
  }
}
