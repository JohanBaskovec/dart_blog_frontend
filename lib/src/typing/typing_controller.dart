import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';

class TypingController extends Controller {
  final HttpClient _httpClient;

  TypingController(this._httpClient);

  @override
  String get hash => r'^text-typing';

  @override
  Future<void> run() async {
    final parameters = getHashParameters();
    if (parameters['id'] != null) {
      try {
        final int id = int.tryParse(parameters['id']);
        if (id == null) {
          // TODO: show error
        } else {
          final Text text =
              await _httpClient.getObject('/texts?id=$id', Text.fromJson);
          // TODO: show error if text is null
          render(text);
        }
      } on FormatException catch (e) {
        print(e);
      }
    }
  }

  void render(Text text) {
    final Element root = document.getElementById('output');
    root.innerHtml = '''
    <h2>${text.title}</h2>
    <div>${text.content}</div>
    <textarea>Type here!</textarea>
    ''';
  }
}
