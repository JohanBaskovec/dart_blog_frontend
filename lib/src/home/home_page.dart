import 'dart:html';

import 'package:blog_common/blog_common.dart';

/// The home page.
class HomePage {
  /// Renders the home page.
  void render(List<BlogPost> blogPosts) {
    final Element root = document.getElementById('output');
    root.innerHtml = '''
    <menu>
      <ul>
        <li>
          <a href="#post-create">Write a new article</a>
        </li>
      </ul>
    </menu>
    ''';
    for (BlogPost blogPost in blogPosts) {
      root.innerHtml += '''
    <div>
      <h3>${blogPost.title}</h3>
      <p>
        ${blogPost.content}
      </p>
    </div>
    ''';
    }
  }
}
