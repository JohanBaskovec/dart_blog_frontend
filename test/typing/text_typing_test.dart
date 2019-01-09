import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/time_service.dart';
import 'package:blog_frontend/src/typing/text_typing.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks_not_http.dart';

void main() {
  TimeService timeService;
  TextTyping textTyping;
  setUp(() {
    timeService = TimeServiceMock();
    textTyping = TextTyping(
        Text('title', 'Ceci est un texte...'), timeService, () {}, () {});
  });

  tearDown(() {
    textTyping.end();
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
      expect(textTyping.statistics.wpmPerWord['Ceci'][0], equals(1.6));

      when(timeService.currentTimestamp).thenReturn(60000);
      textTyping.type(' ');
      // typed 5 characters in 1 minute, WPM should be 1
      expect(textTyping.statistics.wpm, equals(1));
      expect(textTyping.validText, equals('Ceci '));
      expect(textTyping.typedText, equals('Ceci '));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals('est un texte...'));

      final List<double> timeForCUpper = textTyping.statistics.wpmPerChar['C'];
      expect(timeForCUpper, isNull);

      final List<double> timeForE = textTyping.statistics.wpmPerChar['e'];
      expect(timeForE, hasLength(1));
      expect(timeForE[0], equals(120));

      final List<double> timeForCLower = textTyping.statistics.wpmPerChar['c'];
      expect(timeForCLower, hasLength(1));
      expect(timeForCLower[0], equals(120));

      final List<double> timeForI = textTyping.statistics.wpmPerChar['i'];
      expect(timeForI, hasLength(1));
      expect(timeForI[0], equals(0.4026845637583893));

      final List<double> timeForSpace = textTyping.statistics.wpmPerChar[' '];
      expect(timeForSpace, hasLength(1));
      expect(timeForSpace[0], equals(0.4));

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
      expect(textTyping.statistics.wpm, equals(2));
      expect(textTyping.validText, equals('Ceci est un texte...'));
      expect(textTyping.typedText, equals('Ceci est un texte...'));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals(''));
      expect(textTyping.statistics.wpmPerWord['est'][0], equals(3.6));
    });
  });
  group('deleteBackwards', () {
    test('should delete backwards and not break typing', () {
      when(timeService.currentTimestamp).thenReturn(0);
      textTyping.type('Ceci est');
      textTyping.deleteBackwards();
      expect(textTyping.validText, equals('Ceci es'));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals('t un texte...'));
      textTyping.type('t');
      expect(textTyping.validText, equals('Ceci est'));
      expect(textTyping.invalidText, equals(''));
      expect(textTyping.restOfTheText, equals(' un texte...'));
    });
  });
}
