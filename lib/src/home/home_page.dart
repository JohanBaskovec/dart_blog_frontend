import 'dart:html';

class HomePage {
  void render() {
    Element root = document.getElementById("output");
    root.innerHtml = "Hello world!";
  }
}