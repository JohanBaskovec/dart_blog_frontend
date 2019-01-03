import 'package:blog_frontend/src/typing/text_formatter_service.dart';
import 'package:test/test.dart';

void main() {
  group('split', () {
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
      final textSplittingService = TextFormatterService();
      final List<String> paragraphs = textSplittingService.format(text, {
        'ée': 'e',
        '-test': 'test',
        '@e': 'e'
      });
      expect(paragraphs, hasLength(4));
      expect(paragraphs[0], equals('test\ntest\ntest'));
      expect(paragraphs[1], equals('test'));
      expect(paragraphs[2], equals('test'));
      expect(paragraphs[3], equals('test\ntest\ntest\ntest\ntest'));
    });
  });
}