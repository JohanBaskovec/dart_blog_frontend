/// Parent of every controller class of the application.
abstract class Controller {
  /// Loads data and displays an HTML page.
  Future<void> run();

  String get hash;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Controller &&
          runtimeType == other.runtimeType &&
          hash == other.hash;

  @override
  int get hashCode => hash.hashCode;
}
