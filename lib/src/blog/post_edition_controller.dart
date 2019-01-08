import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/blog/post_view_controller.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/dom.dart';
import 'package:blog_frontend/src/hash_utils.dart';
import 'package:blog_frontend/src/http/http_client.dart';

class PostEditionController extends Controller {
  @override
  String get hash => r'^post-create$';
  final BlogPostFactory _blogPostFactory;
  final HttpClient _httpClient;
  final PostViewController _postViewController;

  PostEditionController(
      this._blogPostFactory, this._httpClient, this._postViewController);

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
    final root = byId('output');
    root.innerHtml = '''
      <div>
        <label for="blog-post-title">Tite</label>
        <input id="blog-post-title" value="${blogPost.title}"/>
        <label for="blog-post-content"></label>
        <textarea id="blog-post-content">${blogPost.content}</textarea>
        <button type="button" id="blog-post-submit">Submit</button>
      </div>
    ''';
    final InputElement titleElement = byId('blog-post-title');
    titleElement.onInput.listen((Event event) {
      final target = event.target as InputElement;
      blogPost.title = target.value;
    }); /*String title blogPost.title = title*/

    final TextAreaElement textAreaElement = byId('blog-post-content');
    textAreaElement.onInput.listen((Event event) {
      final target = event.target as TextAreaElement;
      blogPost.content = target.value;
    });

    final ButtonElement submitButton = byId('blog-post-submit');
    submitButton.onClick.listen((MouseEvent event) async {
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
