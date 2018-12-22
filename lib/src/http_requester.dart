abstract class HttpRequester {
  Future<String> request(String url,
      {String method,
      bool withCredentials,
      String responseType,
      String mimeType,
      Map<String, String> requestHeaders,
      sendData});
}
