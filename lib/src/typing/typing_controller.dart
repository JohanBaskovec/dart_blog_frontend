import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/time_service.dart';
import 'package:blog_frontend/src/typing/text_typing.dart';

class TypingController extends Controller {
  final HttpClient _httpClient;

  TypingController(this._httpClient);

  @override
  String get hash => r'^type';

  @override
  Future<void> run() async {
    final parameters = getHashParameters();
    if (parameters['id'] == null) {
      final Text text =
          await _httpClient.getObject('/random-text', Text.fromJson);
      render(text);
    } else {
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
    final timeService = TimeService();
    final textTyping = TextTyping(text, timeService);
    final Element root = document.getElementById('output');
    root.innerHtml = '''
    <h2>${text.title}</h2>
    <div><span id="text-typing-valid"></span><span id="text-typing-invalid"></span><span id="text-typing-rest">${textTyping.restOfTheText}</span></div>
    <textarea id="text-typing-textarea"></textarea>
    ''';
    final TextAreaElement textArea =
        document.getElementById('text-typing-textarea');
    final SpanElement validSpan = document.getElementById('text-typing-valid');
    final SpanElement invalidSpan =
        document.getElementById('text-typing-invalid');
    final SpanElement restSpan = document.getElementById('text-typing-rest');
    int lastLength = 0;
    textArea.onInput.listen((Event e) {
      final String value = textArea.value;
      if (lastLength < value.length) {
        lastLength = value.length;
        final String char = value[value.length - 1];
        textTyping.type(char);
        print('str: $value');
        validSpan.innerHtml = textTyping.validText;
        invalidSpan.innerHtml = textTyping.invalidText;
        restSpan.innerHtml = textTyping.restOfTheText;
      }
    });
    textArea.onKeyDown.listen((KeyboardEvent e) {
      if (e.key == 'Backspace') {
        textTyping.deleteBackwards();
        validSpan.innerHtml = textTyping.validText;
        invalidSpan.innerHtml = textTyping.invalidText;
        restSpan.innerHtml = textTyping.restOfTheText;
      }
    });
  }
}
