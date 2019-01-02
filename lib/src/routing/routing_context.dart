import 'package:blog_frontend/src/post_creation/post_edition_controller.dart';
import 'package:blog_frontend/src/post_creation/post_edition_controller.dart';
import 'package:blog_frontend/src/post_view/post_view_controller.dart';

class RoutingContext {
  PostEditionController _postCreationController;
  PostViewController _postViewController;

  RoutingContext(this._postViewController, this._postCreationController);

  PostEditionController get postCreationController => _postCreationController;
  
  PostViewController get postViewController => _postViewController;
}