import 'dart:convert';
import 'dart:html' hide Text;
import 'dart:typed_data';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/typing/text_formatter_service.dart';

class ParagraphEditionComponent {
  DivElement _root;
  Text _text;
  int _index;

  void Function(int index) _onDelete;

  ParagraphEditionComponent(this._text, this._index) {
    render(_text, _index);
  }

  void render(Text text, int index) {
    _text = text;
    _index = index;
    _root = DivElement();
    final DivElement buttonsDiv = DivElement();
    buttonsDiv.classes = ['text-part-buttons'];
    final deletionButton = ButtonElement();
    deletionButton.classes = ['text-paragraph-deletion-button'];
    deletionButton.innerHtml = 'Delete';
    deletionButton.type = 'button';
    deletionButton.onClick.listen((MouseEvent e) {
      delete();
      if (_onDelete != null) {
        _onDelete(_index);
      }
    });
    buttonsDiv.append(deletionButton);
    _root.append(buttonsDiv);

    final paragraphTextArea = TextAreaElement();
    paragraphTextArea.innerHtml = text.content;
    paragraphTextArea.className = 'text-part-textarea';
    _root.append(paragraphTextArea);
    paragraphTextArea.onKeyUp.listen((KeyboardEvent e) {
      _text.content = paragraphTextArea.value;
    });
  }

  void set onDelete(void Function(int index) callback) => _onDelete = callback;

  void delete() {
    _root.innerHtml = '';
  }
}

class TextEditionController extends Controller {
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
  final HttpClient _httpClient;
  DivElement textPartsDiv;
  int _paragraphMinLength;
  Book _book;

  final Map<String, String> _replacements = Map.from(defaultReplacements);

  TextEditionController(this._httpClient);

  @override
  // TODO: implement hash
  String get hash => r'book-edition';

  @override
  Future<void> run() async {
    final parameters = getHashParameters();
    if (parameters['id'] == null) {
      render(Book());
    }
  }

  void render(Book book) {
    _book = book;
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
      <button type="button" id="text-submit-button">Envoyer</button>
    </div>
    ''';
    final InputElement paragraphMinLengthInput =
        document.getElementById('text-paragraph-min-length');
    paragraphMinLengthInput.onKeyUp.listen((KeyboardEvent e) =>
        _paragraphMinLength = int.parse(paragraphMinLengthInput.value));
    final InputElement fileInput = document.getElementById('text-file');
    textPartsDiv = document.getElementById('text-parts') as DivElement;
    final InputElement textTitleInput = document.getElementById('text-title');
    textTitleInput.onKeyUp
        .listen((KeyboardEvent e) => _book.title = textTitleInput.value);
    final DivElement textReplacementsDiv =
        document.getElementById('text-replacements');

    for (var replacement in _replacements.entries) {
      final Element replacementRow = DivElement();
      replacementRow.innerHtml = '''
      <input type="text" class="text-replacement-key" value="${htmlEscape.convert(replacement.key)}"/>
      <input type="text" class="text-replacement-value" value="${htmlEscape.convert(replacement.value)}"/>
      ''';
      textReplacementsDiv.append(replacementRow);
    }

    fileInput.onChange.listen((Event e) {
      final selectedFile = fileInput.files[0];
      final fileReader = FileReader();
      fileReader.onLoad.listen((Event e) {
        textPartsDiv.innerHtml = '';
        final Uint8List fileContentBytes = fileReader.result;
        final String fileContentString = utf8.decode(fileContentBytes);
        loadText(fileContentString, _paragraphMinLength);
      });
      fileReader.readAsArrayBuffer(selectedFile);
    });

    final ButtonElement submitButton =
        document.getElementById('text-submit-button');
    submitButton.onClick.listen((MouseEvent e) {
      _httpClient.post('/books', _book);
    });

    const String text = '''
test

oki ça marche
bien

lol
    ''';
    loadText(text, 3);
    print(text);
  }

  void loadText(String fileContentString, int paragraphMinLength) {
    final textFormatterService = TextFormatterService();
    final List<String> fileContentParts = textFormatterService.format(
        text: fileContentString,
        minParagraphLengthInChars: paragraphMinLength,
        replacements: _replacements);
    final List<Text> paragraphs = [];
    for (int i = 0; i < fileContentParts.length; i++) {
      final text = Text(i.toString(), fileContentParts[i]);
      text.indexInBook = i;
      paragraphs.add(text);
    }
    _book.paragraphs = paragraphs;
    for (var i = 0; i < paragraphs.length; i++) {
      final paragraphComponent = ParagraphEditionComponent(paragraphs[i], i);
      paragraphComponent.onDelete = (int index) {
        _book.paragraphs.removeAt(index);
      };
      textPartsDiv.append(paragraphComponent._root);
    }
  }
}
