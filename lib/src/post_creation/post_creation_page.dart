import 'dart:html';

class PostCreationPage {
  InputElement _title;
  TextAreaElement _content;

  @override
  void render() {
    final root = document.getElementById('output');
    root.innerHtml = '''
      <div>
        <label for="blog-post-title">Tite</label>
        <input id="blog-post-title" />
        <label for="blog-post-content"></label>
        <textarea id="blog-post-content"></textarea>
      </div>
    ''';
    _title = document.getElementById('blog-post-title') as InputElement;
    _content = document.getElementById('blog-post-content') as TextAreaElement;
  }

  @override
  void onTitleChange(String Function(String title) callback) {
    _title.onChange.listen(print);
  }

  @override
  void onContentChange(String Function(String title) callback) {
    _content.onChange.listen(print);
  }
}