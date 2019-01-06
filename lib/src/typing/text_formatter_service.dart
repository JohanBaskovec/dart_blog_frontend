/// Service for splitter a text into paragraphs and
/// replacing chains from it.
class TextFormatterService {
  List<String> format(
      {String text,
      int minParagraphLengthInChars,
      Map<String, String> replacements}) {
    String textWithoutCarriageReturn =
        text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    for (var replacement in replacements.entries) {
      textWithoutCarriageReturn = textWithoutCarriageReturn.replaceAll(
          replacement.key, replacement.value);
    }
    final List<String> paragraphs = textWithoutCarriageReturn
        .split('\n\n')
        .map((String paragraph) => paragraph.trim().replaceAll('\n', ' '))
        .toList()
          ..retainWhere((String paragraph) => paragraph != '');
    final List<String> paragraphsWithProperLength = [];
    var i = 0;
    while (i < paragraphs.length) {
      final StringBuffer current = StringBuffer();
      current.write(paragraphs[i]);
      i++;
      while (
          current.length < minParagraphLengthInChars && i < paragraphs.length) {
        current.write('\n');
        current.write(paragraphs[i]);
        i++;
      }
      paragraphsWithProperLength.add(current.toString());
    }
    return paragraphsWithProperLength;
  }
}
