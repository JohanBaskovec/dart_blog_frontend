import 'dart:html';
import 'dart:convert';

import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';

class TextEditionController extends Controller {
  final HttpClient _httpClient;

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
    final Element root = document.getElementById('output');
    root.innerHtml = '''
    <div>
      <p>Upload a text file and split it into multiple texts.</p>
      <label for="text-title">Title</label><input type="text" id="text-title" />
      <label for="text-file">File</label><input type="file" id="text-file" accept=".txt"/>
      <label for="text-min-length">Minimum text length</label><input type="number" id="text-min-length" />
      <label for="text-max-length">Maximum text length</label><input type="number" id="text-max-length" />
      <button type="button" id="text-submit-button">Submit</button>
    </div>
    ''';

    final ButtonElement submitButton =
        document.getElementById('text-submit-button');
    submitButton.onClick.listen((MouseEvent e) {
      final InputElement textTitleInput = document.getElementById('text-title');
      final InputElement textMinLengthInput =
          document.getElementById('text-min-length');
      final InputElement textMaxLengthInput =
          document.getElementById('text-max-length');
      final InputElement textFileInput = document.getElementById('text-file');
      final selectedFile = textFileInput.files[0];
      final fileReader = FileReader();
      // TODO: convert to async
      fileReader.onLoad.listen((Event e) {
        String fileContent = (e.target as dynamic).result;
        final List<int> fileContentBytes = utf8.encode(fileContent);
        final fileContentAsBase64 = base64.encode(fileContentBytes);
        final Map<String, String> form = {
          'title': textTitleInput.value,
          'text': fileContentAsBase64
        };
      });
      fileReader.readAsText(selectedFile);
    });
  }
}
