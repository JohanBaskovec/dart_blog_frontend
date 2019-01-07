import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/time_service.dart';

class TextTyping {
  final Text text;
  String typedText = '';
  String validText = '';
  String invalidText = '';
  String restOfTheText;
  int longestValidText = 0;
  int timestampLastCharacterTyped = 0;
  bool typingStarted = false;
  int timestampStart = 0;
  TimeService timeService;

  TextTyping(this.text, this.timeService): restOfTheText = text.content;

  void validate(String typedText) {
    this.typedText = typedText;
    if (typedTextIsValid()) {
      validText = typedText;
      invalidText = '';
      final int timestamp = timeService.currentTimestamp;
      if (typedText.length != 1 && longestValidText < validText.length) {
        longestValidText = validText.length;
      }
      timestampLastCharacterTyped = timestamp;
    } else {
      invalidText = text.content.substring(validText.length, typedText.length);
    }
    restOfTheText = text.content.substring(typedText.length);
  }

  void deleteBackwards() {
    typedText = typedText.substring(0, typedText.length - 1);
    if (invalidText.isNotEmpty) {
      invalidText = invalidText.substring(0, invalidText.length - 1);
    } else {
      validText = validText.substring(0, validText.length - 1);
    }
  }

  bool typedTextIsValid() => text.content.indexOf(typedText) == 0;
}