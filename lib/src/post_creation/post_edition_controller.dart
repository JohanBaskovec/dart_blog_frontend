import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/post_view/post_view_controller.dart';

class PostEditionController extends Controller {
  @override
  String get hash => r'^post-create$';
  final BlogPostFactory _blogPostFactory;
  final HttpClient _httpClient;
  final PostViewController _postViewController;
  InputElement _title;
  TextAreaElement _content;


  ButtonElement _submit;

  PostEditionController(this._blogPostFactory, this._httpClient,
      this._postViewController);

  @override
  Future<void> run() async {
    final Map<String, String> hashParameters = getHashParameters();
    final String idParameter = hashParameters['id'];
    BlogPost blogPost;
    if (idParameter == null) {
      blogPost = _blogPostFactory.newInstance();
    } else {
      final int id = int.parse(idParameter);
      blogPost = await _httpClient.getObject('/post?id=$id', BlogPost.fromJson);
    }
    assert(blogPost != null);
    render(blogPost);
  }

  void render(BlogPost blogPost) {
    final root = document.getElementById('output');
    root.innerHtml = '''
      <div>
        <label for="blog-post-title">Tite</label>
        <input id="blog-post-title" value="${blogPost.title}"/>
        <label for="blog-post-content"></label>
        <textarea id="blog-post-content">${blogPost.content}</textarea>
        <button type="button" id="blog-post-submit">Submit</button>
      </div>
    ''';
    _title = document.getElementById('blog-post-title') as InputElement;
    _title.onInput.listen((Event event) {
      final target = event.target as InputElement;
      blogPost.title = target.value;
    }); /*String title blogPost.title = title*/

    _content = document.getElementById('blog-post-content') as TextAreaElement;
    _content.onInput.listen((Event event) {
      final target = event.target as TextAreaElement;
      blogPost.content = target.value;
    });

    _submit = document.getElementById('blog-post-submit') as ButtonElement;
    _submit.onClick.listen((MouseEvent event) async {
      await _post(blogPost);
    });
  }

  Future _post(BlogPost blogPost) async {
    final BlogPost response =
    await _httpClient.post('/posts', blogPost, BlogPost.fromJson);
    _postViewController.render(response);
    window.history.pushState(
        null, '#post-view?id=${response.id}', '#post-view?id=${response.id}');
  }
}
