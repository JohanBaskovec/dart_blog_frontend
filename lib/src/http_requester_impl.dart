import 'dart:html';

import 'package:blog_frontend/src/http_requester.dart';

class HttpRequesterImpl implements HttpRequester {
  Future<String> request(String url,
      {String method,
      bool withCredentials,
      String responseType,
      String mimeType,
      Map<String, String> requestHeaders,
      sendData}) {
    HttpRequest.request(url,
        method: method,
        withCredentials: withCredentials,
        responseType: responseType,
        mimeType: mimeType,
        requestHeaders: requestHeaders,
        sendData: sendData).then((req) => req.responseText );
  }
}
