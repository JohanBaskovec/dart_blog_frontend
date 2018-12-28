import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/post_creation/post_creation_page_factory.dart';

class PostCreationController extends Controller {
  final PostCreationPageFactory _postCreationPageFactory;

  PostCreationController(this._postCreationPageFactory);

  @override
  void run() {
    final postCreationPage = _postCreationPageFactory.create();
    postCreationPage.render();
  }
}