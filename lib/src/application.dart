import 'dart:html';

import 'package:blog_common/blog_common.dart';

class Application {
  void run() {
    final blogPost = BlogPost(title: "hello", content: "world");
    document.getElementById("output").innerHtml =
        '${blogPost.title}: ${blogPost.content}';
  }
}
