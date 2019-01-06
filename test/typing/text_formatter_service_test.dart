import 'package:blog_frontend/src/typing/text_formatter_service.dart';
import 'package:test/test.dart';

void main() {
  group('format', () {
    test('should split text by paragraph and replace characters', () {
      const String text = 'test\r\n'
          'test\n'
          'test\r\n\r\n\r\n'
          'test\n\n\n\n\n'
          'test\r\n\r\n\r\n\r\n\r\n\r\n\n\n\n\n\r\n'
          't@est\n'
          'test\r'
          '-test\r'
          'test\n'
          'téest\r\n';
      final textFormatterService = TextFormatterService();
      final List<String> paragraphs = textFormatterService.format(
          text: text,
          minParagraphLengthInChars: 15,
          replacements: {'ée': 'e', '-test': 'test', '@e': 'e'});
      expect(paragraphs, hasLength(2));
      expect(paragraphs[0], equals('test test test\ntest'));
      expect(paragraphs[1], equals('test\ntest test test test test'));
    });
  });
}
