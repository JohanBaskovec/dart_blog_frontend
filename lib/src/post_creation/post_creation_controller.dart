import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/post_view/post_view_controller.dart';

class PostCreationController extends Controller {
  final BlogPostFactory _blogPostFactory;
  final HttpClient _httpClient;
  final PostViewController _postViewController;
  InputElement _title;
  TextAreaElement _content;

  BlogPost _blogPost;

  ButtonElement _submit;

  PostCreationController(this._blogPostFactory, this._httpClient,
      this._postViewController);

  @override
  void run() {
    _blogPost = _blogPostFactory.newInstance();
    render();
  }

  void render() {
    final root = document.getElementById('output');
    root.innerHtml = '''
      <div>
        <label for="blog-post-title">Tite</label>
        <input id="blog-post-title" />
        <label for="blog-post-content"></label>
        <textarea id="blog-post-content"></textarea>
        <button type="button" id="blog-post-submit">Submit</button>
      </div>
    ''';
    _title = document.getElementById('blog-post-title') as InputElement;
    _title.onInput.listen((Event event) {
      final target = event.target as InputElement;
      _blogPost.title = target.value;
    }); /*String title blogPost.title = title*/

    _content = document.getElementById('blog-post-content') as TextAreaElement;
    _content.onInput.listen((Event event) {
      final target = event.target as TextAreaElement;
      _blogPost.content = target.value;
    });

    _submit = document.getElementById('blog-post-submit') as ButtonElement;
    _submit.onClick.listen((MouseEvent event) async {
      await _post();
    });
  }

  Future _post() async {
    final BlogPost response =
    await _httpClient.post('/posts', _blogPost, BlogPost.fromJson);
    _postViewController.render(response);
    window.history.pushState(
        null, '#post-view?id=${response.id}', '#post-view?id=${response.id}');
  }
}
