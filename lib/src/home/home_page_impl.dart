import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/home/home_page.dart';

/// The home page.
class HomePageImpl implements HomePage {
  /// Renders the home page.
  @override
  void render(List<BlogPost> blogPosts) {
    final Element root = document.getElementById('output');
    root.innerHtml += '''
    <menu>
      <ul>
        <li>
          Write a new article
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