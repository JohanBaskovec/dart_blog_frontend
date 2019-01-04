import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/typing/text_formatter_service.dart';

class TextEditionController extends Controller {
  final HttpClient _httpClient;
  static const Map<String, String> defaultReplacements = {
    '“': '"',
    '”': '"',
    '’': "'",
    '‘': "'",
    '—': '-',
    'á': 'a',
    'í': 'i',
    'À': 'A',
    'ó': 'o',
    'æ': 'ae',
  };

  TextEditionController(this._httpClient);

  @override
  // TODO: implement hash
  String get hash => r'^text-edition';

  @override
  Future<void> run() async {
    final parameters = getHashParameters();
    if (parameters['id'] == null) {
      render();
    }
  }

  void render() {
    final textFormatterService = TextFormatterService();
    final Element root = document.getElementById('output');
    root.innerHtml = '''
    <div>
      <p>Upload a text file and split it into multiple texts.</p>
      <label for="text-title">Title</label><input type="text" id="text-title" />
      <label for="text-file">File</label><input type="file" id="text-file" accept=".txt"/>
      <label for="text-paragraph-min-length">Paragraph minimum size</label>
      <input type="number" id="text-paragraph-min-length" value="500"/>
      <div id="text-replacements">
      <h3>Replacement strings</h3>
      </div>
      <div id="text-parts">
      </div>
    </div>
    ''';
    List<String> paragraphs = [];
    final InputElement paragraphMinLengthInput =
        document.getElementById('text-paragraph-min-length');
    final InputElement fileInput = document.getElementById('text-file');
    final DivElement textPartsDiv = document.getElementById('text-parts');
    final InputElement textTitleInput = document.getElementById('text-title');
    final DivElement textReplacementsDiv =
        document.getElementById('text-replacements');
    final Map<String, String> replacements = Map.from(defaultReplacements);
    for (var replacement in replacements.entries) {
      final Element replacementRow = DivElement();
      replacementRow.innerHtml = '''
      <input type="text" class="text-replacement-key" value="${htmlEscape.convert(replacement.key)}"/>
      <input type="text" class="text-replacement-value" value="${htmlEscape.convert(replacement.value)}"/>
      ''';
      textReplacementsDiv.append(replacementRow);
    }

    final ButtonElement submitButton =
        document.getElementById('text-submit-button');
    fileInput.onChange.listen((Event e) {
      final selectedFile = fileInput.files[0];
      final fileReader = FileReader();
      fileReader.onLoad.listen((Event e) {
        final Uint8List fileContentBytes = fileReader.result;
        final String fileContentString = utf8.decode(fileContentBytes);
        final int minLength = int.parse(paragraphMinLengthInput.value);
        paragraphs = textFormatterService.format(
            text: fileContentString,
            minParagraphLengthInChars: minLength,
            replacements: replacements);
        for (var i = 0; i < paragraphs.length; i++) {
          final String paragraph = paragraphs[i];
          final paragraphDiv = DivElement();
          paragraphDiv.setInnerHtml('''
          <div class="text-part-buttons">
          <button type="button" data-id="$i" class="text-paragraph-deletion-button">Delete</button>
          </div>
          <textarea class="text-part-textarea">$paragraph</textarea>
          ''', treeSanitizer: NodeTreeSanitizer.trusted);
          textPartsDiv.append(paragraphDiv);
        }
        textPartsDiv.onClick.listen((MouseEvent e) {
          if (e.target is ButtonElement) {
            final element = e.target as ButtonElement;
            if (element.classes.contains('text-paragraph-deletion-button')) {
              final int id = int.parse(element.dataset['id']);
              paragraphs.removeAt(id);
              element.parent.parent.setAttribute('hidden', 'hidden');
            }
          }
        });
      });
      fileReader.readAsArrayBuffer(selectedFile);
    });
  }
}
