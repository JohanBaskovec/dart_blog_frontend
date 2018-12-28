import 'dart:html';

import 'package:blog_frontend/src/post_creation/post_creation_page.dart';

class PostCreationPageImpl implements PostCreationPage {
  @override
  void render() {
    final root = document.getElementById('output');
    root.innerHtml = '''
      <div>
        <label for="blog-post-title">Tite</label>
        <input id="blog-post-title" />
        <label for="blog-post-content"></label>
        <textarea id="blog-post-content"></textarea>
      </div>
    ''';
  }

}