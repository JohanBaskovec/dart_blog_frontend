import 'package:blog_frontend/src/post_creation/post_creation_controller.dart';
import 'package:blog_frontend/src/post_creation/post_creation_controller.dart';
import 'package:blog_frontend/src/post_view/post_view_controller.dart';

class RoutingContext {
  PostCreationController _postCreationController;
  PostViewController _postViewController;

  RoutingContext(this._postViewController, this._postCreationController);

  PostCreationController get postCreationController => _postCreationController;
  
  PostViewController get postViewController => _postViewController;
}