abstract class Server {
  Future<T> get<T>(String url, T fromJson(Map<String, dynamic> json));
}
