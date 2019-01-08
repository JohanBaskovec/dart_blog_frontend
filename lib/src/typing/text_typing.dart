import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/time_service.dart';

class TextTyping {
  final Text text;
  String _typedText = '';
  String _validText = '';
  String _invalidText = '';
  String _restOfTheText;
  int _longestValidText = 0;
  int _timestampLastCharacterTyped = 0;
  int _timestampLastWordFirstChar;
  int _timestampStart;
  TimeService _timeService;
  final Map<String, List<int>> _timePerChar = {};
  final Map<String, List<int>> _timePerWord = {};
  int _lastWordIndex;
  double _wpm;

  TextTyping(this.text, this._timeService) : _restOfTheText = text.content;

  void type(String typedText) {
    _typedText += typedText;
    _restOfTheText = text.content.substring(_typedText.length);
    final currentTimestamp = _timeService.currentTimestamp;
    if (typedTextIsValid()) {
      _validText = _typedText;
      _invalidText = '';
      final int timestamp = _timeService.currentTimestamp;
      final String lastCharacter = _validText[_validText.length - 1];
      final bool nextCharIsPunctuationOrEndOfText =
          _restOfTheText.isEmpty || charIsPunctuation(_restOfTheText[0]);

      if (_timestampStart == null) {
        _timestampStart = currentTimestamp;
      } else {
        final int totalTime = currentTimestamp - _timestampStart;
        final double totalTimeMinutes = (totalTime / 1000) / 60;
        final int nTypedChars = _typedText.length;
        final double nTypedWords = nTypedChars / 5;
        _wpm = nTypedWords / totalTimeMinutes;

        // ignore the speed of the first character
        // because its typing speed would be infinite
        if (_validText.length > 1 && _longestValidText < _validText.length) {
          _longestValidText = _validText.length;
          List<int> times = _timePerChar[lastCharacter];

          if (times == null) {
            times = [];
            _timePerChar[lastCharacter] = times;
          }
          times.add(timestamp - _timestampLastCharacterTyped);

          _timestampLastCharacterTyped = timestamp;
        }
      }

      if (nextCharIsPunctuationOrEndOfText && _lastWordIndex != null) {
        final String word = _validText.substring(_lastWordIndex);
        List<int> timesForWord = _timePerWord[word];
        if (timesForWord == null) {
          timesForWord = [];
          _timePerWord[word] = timesForWord;
        }
        timesForWord.add(timestamp - _timestampLastWordFirstChar);
        _lastWordIndex = null;
        _timestampLastWordFirstChar = null;
      } else if (_lastWordIndex == null && !charIsPunctuation(typedText)){
        _timestampLastWordFirstChar = timestamp;
        _lastWordIndex = _validText.length - 1;
      }
    } else {
      _invalidText =
          text.content.substring(_validText.length, _typedText.length);
    }
  }

  void deleteBackwards() {
    _typedText = _typedText.substring(0, _typedText.length - 1);
    if (_invalidText.isNotEmpty) {
      _invalidText = _invalidText.substring(0, _invalidText.length - 1);
    } else {
      _validText = _validText.substring(0, _validText.length - 1);
    }
    _restOfTheText = text.content.substring(_typedText.length);
  }

  bool charIsPunctuation(String char) {
    return char == ' ' ||
        char == '.' ||
        char == '!' ||
        char == ',' ||
        char == ';' ||
        char == '(' ||
        char == ')' ||
        char == '_' ||
        char == '-' ||
        char == '[' ||
        char == ']' ||
        char == '=' ||
        char == '\$' ||
        char == '*' ||
        char == ':' ||
        char == '?' ||
        char == '%' ||
        char == "'" ||
        char == '"' ||
        char == '&';
  }

  bool typedTextIsValid() => text.content.indexOf(_typedText) == 0;

  String get restOfTheText => _restOfTheText;

  String get invalidText => _invalidText;

  String get validText => _validText;

  String get typedText => _typedText;

  double get wpm => _wpm;

  Map<String, List<int>> get timePerWord => _timePerWord;

  Map<String, List<int>> get timePerChar => _timePerChar;
}
