import 'dart:html';

/// The home page.
class HomePage {
  /// Renders the home page.
  void render() {
    final Element root = document.getElementById('output');
    root.innerHtml = 'Hello world!';
  }
}