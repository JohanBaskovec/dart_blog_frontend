import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/post_creation/post_creation_page_factory.dart';

class PostCreationController extends Controller {
  final PostCreationPageFactory _postCreationPageFactory;
  final BlogPostFactory _blogPostFactory;

  PostCreationController(this._postCreationPageFactory, this._blogPostFactory);

  @override
  void run() {
    final postCreationPage = _postCreationPageFactory.create();
    final blogPost = _blogPostFactory.newInstance();
    postCreationPage.render();
    postCreationPage.onTitleChange((String title) => blogPost.title = title);
    postCreationPage
        .onContentChange((String content) => blogPost.content = content);
  }
}
