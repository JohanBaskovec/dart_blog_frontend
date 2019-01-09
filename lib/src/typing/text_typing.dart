import 'dart:async';

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
  final TypingStatistics _typingStatistics;
  int _lastWordIndex;
  Timer _statisticsUpdateTimer;
  Function _onStatisticsUpdate;
  Function _onDone;

  /// Creates a new TextTyping
  ///
  /// After the first call to type(), a Timer is started and _onStatisticsUpdate
  /// is executed every 50 milliseconds. You must call end() after you're
  /// done with the object to cancel the timer.
  TextTyping(
      this.text, this._timeService, this._onStatisticsUpdate, this._onDone)
      : _restOfTheText = text.content,
        _typingStatistics = TypingStatistics(text.id);

  void type(String typedText) {
    _typedText += typedText;
    _restOfTheText = text.content.substring(_typedText.length);
    if (typedTextIsValid()) {
      _validText = _typedText;
      _invalidText = '';
      final int timestamp = _timeService.currentTimestamp;
      final String lastCharacter = _validText[_validText.length - 1];
      final bool nextCharIsPunctuationOrEndOfText =
          _restOfTheText.isEmpty || charIsPunctuation(_restOfTheText[0]);

      if (_timestampStart == null) {
        _timestampStart = _timeService.currentTimestamp;
        _statisticsUpdateTimer =
            Timer.periodic(Duration(milliseconds: 50), (Timer timer) {
          if (_onStatisticsUpdate != null) {
            updateStatistics();

            _onStatisticsUpdate();
          }
        });
      } else {
        // ignore the speed of the first character
        // because its typing speed would be infinite
        // TODO: ignore the first word for the same reason
        if (_validText.length > 1 && _longestValidText < _validText.length) {
          _longestValidText = _validText.length;
          List<double> charWpms = _typingStatistics.wpmPerChar[lastCharacter];

          if (charWpms == null) {
            charWpms = [];
            _typingStatistics.wpmPerChar[lastCharacter] = charWpms;
          }
          const double nWords = 1 / 5;
          final int timeMs = timestamp - _timestampLastCharacterTyped;
          final double timeMinutes = timeMs / 60000;
          final double wpm = nWords / timeMinutes;
          charWpms.add(wpm);
        }
      }

      if (nextCharIsPunctuationOrEndOfText && _lastWordIndex != null) {
        final String word = _validText.substring(_lastWordIndex);
        List<double> timesForWord = _typingStatistics.wpmPerWord[word];
        if (timesForWord == null) {
          timesForWord = [];
          _typingStatistics.wpmPerWord[word] = timesForWord;
        }
        final double nWords = word.length / 5;
        final int timeMs = timestamp - _timestampLastWordFirstChar;
        final double timeMinutes = timeMs / 60000;
        final double wpm = nWords / timeMinutes;
        timesForWord.add(wpm);
        _lastWordIndex = null;
        _timestampLastWordFirstChar = null;
      } else if (_lastWordIndex == null && !charIsPunctuation(typedText)) {
        _timestampLastWordFirstChar = timestamp;
        _lastWordIndex = _validText.length - 1;
      }
      _timestampLastCharacterTyped = timestamp;
    } else {
      _invalidText =
          text.content.substring(_validText.length, _typedText.length);
    }
    updateStatistics();
  }

  void updateStatistics() {
    if (_timestampStart != null) {
      final int totalTime = _timeService.currentTimestamp - _timestampStart;
      final double totalTimeMinutes = (totalTime / 1000) / 60;
      final int nTypedChars = _typedText.length;
      final double nTypedWords = nTypedChars / 5;
      _typingStatistics.wpm = nTypedWords / totalTimeMinutes;
      if (text.content == typedText) {
        _statisticsUpdateTimer.cancel();
        _onDone();
      }
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
    updateStatistics();
  }

  void end() {
    if (_statisticsUpdateTimer != null) {
      _statisticsUpdateTimer.cancel();
    }
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

  TypingStatistics get statistics => _typingStatistics;

  Duration get elapsedTime {
    final int currentTimestamp = _timeService.currentTimestamp;
    final int msSinceLastCharTyped = currentTimestamp - _timestampStart;
    return Duration(milliseconds: msSinceLastCharTyped);
  }
}
