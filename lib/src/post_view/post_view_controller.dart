import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';

class PostViewController extends Controller {
  final HttpClient _httpClient;

  PostViewController(this._httpClient);

  @override
  Future<void> run() async {
    final parameters = getHashParameters();
    if (parameters['id'] != null) {
      try {
        final int id = int.tryParse(parameters['id']);
        if (id == null) {
          // TODO: show error
        } else {
          final BlogPost blogPost =
              await _httpClient.getObject('/posts?id=$id', BlogPost.fromJson);
          // TODO: show error if blogPost is null
          render(blogPost);
        }
      } on FormatException catch (e) {
        print(e);
      }
    }
  }

  void render(BlogPost blogPost) {
    final root = document.getElementById('output');
    root.innerHtml = '''
    <div>
      <h2>${blogPost.title}</h2>
      <div>${blogPost.content}</div>
    </div>
    ''';
  }
}
