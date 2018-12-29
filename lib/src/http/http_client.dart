/// An HTTP client that converts responses to objects.
abstract class HttpClient {
  /// Sends a GET request to [url] and converts the response
  /// to [T] by using [fromJson]
  Future<T> getObject<T>(String url, T fromJson(Map json));

  /// Sends a GET request to [url] and converts the response
  /// to List<[T]> by using [fromJson]
  Future<List<T>> getArray<T>(
      String url, T fromJson(Map json));
}
