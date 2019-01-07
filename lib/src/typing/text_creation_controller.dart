import 'dart:html' hide Text;
import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/typing/typing_controller.dart';

class TextCreationController extends Controller {
  @override
  String get hash => 'text-creation';

  final HttpClient _httpClient;
  final TypingController _typingController;

  TextCreationController(this._httpClient, this._typingController);

  @override
  Future<void> run() async {
    final DivElement root = document.getElementById('output');
    final text = Text();
    root.innerHtml = '''
      <div>
        <label for="text-title">Tite</label>
        <input id="text-title" value="${text.title}"/>
        <label for="text-content"></label>
        <textarea id="text-content">${text.content}</textarea>
        <button type="button" id="text-submit">Submit</button>
      </div>
    ''';
    final titleElement = document.getElementById('text-title') as InputElement;
    titleElement.onInput.listen((Event event) {
      final target = event.target as InputElement;
      text.title = target.value;
    });

    final contentElement =
        document.getElementById('text-content') as TextAreaElement;
    contentElement.onInput.listen((Event event) {
      final target = event.target as TextAreaElement;
      text.content = target.value;
    });

    final submitButton =
        document.getElementById('text-submit') as ButtonElement;
    submitButton.onClick.listen((MouseEvent event) async {
      final Text response =
          await _httpClient.post('/texts', text, Text.fromJson);
      _typingController.render(response);
      window.history.pushState(
          null, '#type?id=${response.id}', '#type?id=${response.id}');
    });
  }
}
