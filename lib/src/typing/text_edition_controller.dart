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
      <div id="text-replacements">
      </div>
      <div id="text-parts">
      </div>
    </div>
    ''';
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
        final List<String> textParts =
            textFormatterService.format(fileContentString, replacements);
        for (var part in textParts) {
          final textAreaElement = TextAreaElement();
          textAreaElement.className = 'text-part-textarea';
          textAreaElement.innerHtml = part;
          textPartsDiv.append(textAreaElement);
        }

        final Map<String, String> form = {
          'title': textTitleInput.value,
        };
      });
      fileReader.readAsArrayBuffer(selectedFile);
    });
  }
}
