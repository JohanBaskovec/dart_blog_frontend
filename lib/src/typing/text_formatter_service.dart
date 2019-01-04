/// Service for splitter a text into paragraphs and
/// replacing chains from it.
class TextFormatterService {
  List<String> format(String text, Map<String, String> replacements) {
    String textWithoutCarriageReturn =
        text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    for (var replacement in replacements.entries) {
      textWithoutCarriageReturn = textWithoutCarriageReturn.replaceAll(
          replacement.key, replacement.value);
    }
    final List<String> paragraphs = textWithoutCarriageReturn
        .split('\n\n')
        .map((String paragraph) => paragraph.replaceAll('\n', ' ').trim())
        .toList()
          ..retainWhere((String paragraph) => paragraph != '');
    return paragraphs;
  }
}
