import 'dart:async';
import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/dom.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/time_service.dart';
import 'package:blog_frontend/src/typing/text_typing.dart';

/// Copy of Dart's Duration but without the microseconds because the SDK
/// doesn't provide a duration formatter...
///
/// Returns a string representation of the `Duration`.
///
/// Returns a string with hours, minutes, seconds, in the
/// following format: `HH:MM:SS`. For example,
///
///    var d = new Duration(days:1, hours:1, minutes:33, microseconds: 500);
///    d.toString();  // "25:33:00"
String durationToString(Duration duration) {
  String twoDigits(num n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  if (duration.inMicroseconds < 0) {
    return '-${-duration}';
  }
  final String twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final String twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
}

class TypingController extends Controller {
  final HttpClient _httpClient;

  TextTyping _textTyping;

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
    final Element root = byId('output');
    root.innerHtml = '''
    <h2>${text.title}</h2>
    <div><span id="text-typing-valid"></span><span id="text-typing-invalid"></span><span id="text-typing-rest"></span></div>
    <textarea id="text-typing-textarea"></textarea>
    <div id="text-typing-statistics">
      <ul>
        <li>Time: <span id="text-typing-statistics-time"</li>
        <li>WPM:  <span id="text-typing-statistics-wpm"</li>
      </ul>
    </div>
    ''';
    final SpanElement timeSpan =
        byId('text-typing-statistics-time');
    final SpanElement wpmSpan =
        byId('text-typing-statistics-wpm');
    _textTyping = TextTyping(text, timeService, () {
      timeSpan.innerHtml = durationToString(_textTyping.elapsedTime);
      wpmSpan.innerHtml = _textTyping.wpm.toStringAsFixed(2);
    });
    final TextAreaElement textArea =
        byId('text-typing-textarea');
    final SpanElement validSpan = byId('text-typing-valid');
    final SpanElement restOfTheTextSpan =
        byId('text-typing-rest');
    restOfTheTextSpan.innerHtml = _textTyping.restOfTheText;
    final SpanElement invalidSpan =
        byId('text-typing-invalid');
    final SpanElement restSpan = byId('text-typing-rest');
    int lastLength = 0;
    textArea.onInput.listen((Event e) {
      final String value = textArea.value;
      if (lastLength < value.length) {
        lastLength = value.length;
        final String char = value[value.length - 1];
        _textTyping.type(char);
        print('str: $value');
        validSpan.innerHtml = _textTyping.validText;
        invalidSpan.innerHtml = _textTyping.invalidText;
        restSpan.innerHtml = _textTyping.restOfTheText;
      }
    });
    textArea.onKeyDown.listen((KeyboardEvent e) {
      if (e.key == 'Backspace') {
        _textTyping.deleteBackwards();
        validSpan.innerHtml = _textTyping.validText;
        invalidSpan.innerHtml = _textTyping.invalidText;
        restSpan.innerHtml = _textTyping.restOfTheText;
      }
    });
  }

  @override
  Future<void> onLeave() async {
    _textTyping.end();
  }
}
