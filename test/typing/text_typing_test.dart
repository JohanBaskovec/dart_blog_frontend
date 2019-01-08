import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/time_service.dart';
import 'package:blog_frontend/src/typing/text_typing.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../mocks_not_http.dart';

void main() {
  TimeService timeService;
  TextTyping textTyping;
  setUp(() {
    timeService = TimeServiceMock();
    textTyping = TextTyping(Text('title', 'Ceci est un texte...'), timeService);
  });

  group('validate', () {
    test('should make validText the entire text when text is valid', () {
      when(timeService.currentTimestamp).thenReturn(0);
      textTyping.type('C');
      when(timeService.currentTimestamp).thenReturn(100);
      textTyping.type('e');
      when(timeService.currentTimestamp).thenReturn(200);
      textTyping.type('c');
      when(timeService.currentTimestamp).thenReturn(30000);
      textTyping.type('i');
      expect(textTyping.timePerWord['Ceci'][0], equals(30000));

      when(timeService.currentTimestamp).thenReturn(60000);
      textTyping.type(' ');
      // typed 5 characters in 1 minute, WPM should be 1
      expect(textTyping.wpm, equals(1));
      expect(textTyping.validText, equals('Ceci '));
      expect(textTyping.typedText, equals('Ceci '));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals('est un texte...'));

      final List<int> timeForCUpper = textTyping.timePerChar['C'];
      expect(timeForCUpper, isNull);

      final List<int> timeForE = textTyping.timePerChar['e'];
      expect(timeForE, hasLength(1));
      expect(timeForE[0], equals(100));

      final List<int> timeForCLower = textTyping.timePerChar['c'];
      expect(timeForCLower, hasLength(1));
      expect(timeForCLower[0], equals(100));

      final List<int> timeForI = textTyping.timePerChar['i'];
      expect(timeForI, hasLength(1));
      expect(timeForI[0], equals(30000 - 200));

      final List<int> timeForSpace = textTyping.timePerChar[' '];
      expect(timeForSpace, hasLength(1));
      expect(timeForSpace[0], equals(30000));

      when(timeService.currentTimestamp).thenReturn(40000);
      textTyping.type('e');
      when(timeService.currentTimestamp).thenReturn(45000);
      textTyping.type('s');
      when(timeService.currentTimestamp).thenReturn(50000);
      textTyping.type('t');
      when(timeService.currentTimestamp).thenReturn(55000);
      textTyping.type(' ');
      when(timeService.currentTimestamp).thenReturn(60000);
      textTyping.type('u');
      when(timeService.currentTimestamp).thenReturn(65000);
      textTyping.type('n');
      when(timeService.currentTimestamp).thenReturn(70000);
      textTyping.type(' ');
      when(timeService.currentTimestamp).thenReturn(750000);
      textTyping.type('t');
      when(timeService.currentTimestamp).thenReturn(80000);
      textTyping.type('e');
      when(timeService.currentTimestamp).thenReturn(85000);
      textTyping.type('x');
      when(timeService.currentTimestamp).thenReturn(90000);
      textTyping.type('t');
      when(timeService.currentTimestamp).thenReturn(95000);
      textTyping.type('e');
      when(timeService.currentTimestamp).thenReturn(100000);
      textTyping.type('.');
      when(timeService.currentTimestamp).thenReturn(105000);
      textTyping.type('.');
      when(timeService.currentTimestamp).thenReturn(120000);
      textTyping.type('.');
      // 4 'words' (20 chars) in 2 minutes
      expect(textTyping.wpm, equals(2));
      expect(textTyping.validText, equals('Ceci est un texte...'));
      expect(textTyping.typedText, equals('Ceci est un texte...'));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals(''));
      expect(textTyping.timePerWord['est'][0], equals(10000));
      expect(textTyping.timePerWord['un'][0], equals(5000));
    });
  });
}
