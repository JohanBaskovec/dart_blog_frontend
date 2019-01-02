import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/post_creation/post_edition_controller.dart';

class PostViewController extends Controller {
  @override
  String get hash => r'^post-view';

  final HttpClient _httpClient;
  PostEditionController postEditionController;

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
      <h2>${blogPost.title} <button type="button" id="post-edit-button">Edit</button> </h2>
      <div>${blogPost.content}</div>
    </div>
    ''';
    document.getElementById('post-edit-button').onClick.listen((MouseEvent e) {
      postEditionController.render(blogPost);
    });
  }
}
