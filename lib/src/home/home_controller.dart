import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/http/http_client.dart';

/// The home page's controller.
class HomeController extends Controller {
  HttpClient _httpClient;

  /// Creates a new HomeController.
  HomeController(this._httpClient);

  /// Renders the page.
  @override
  Future<void> run() async {
    final List<BlogPost> blogPosts =
        await _httpClient.getArray('/posts', BlogPost.fromJson);
    render(blogPosts);
  }

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
      <h3><a href="#post-view?id=${blogPost.id}"${blogPost.title}</h3>
      <p>
        ${blogPost.content}
      </p>
    </div>
    ''';
    }
  }
}
