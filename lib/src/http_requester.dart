/// Sends requests to a Server.
///
/// The point of this class is to have an interface for HTTP requests
/// that doesn't depend on dart:html.
abstract class HttpRequester {
  /// Sends a request and return the result as a String.
  Future<String> request(String url,
      {String method,
      bool withCredentials,
      String responseType,
      String mimeType,
      Map<String, String> requestHeaders,
      dynamic sendData});
}
