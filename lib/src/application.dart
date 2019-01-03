import 'dart:html';

import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/blog/home_controller.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/http/http_requester.dart';
import 'package:blog_frontend/src/blog/post_edition_controller.dart';
import 'package:blog_frontend/src/blog/post_view_controller.dart';
import 'package:blog_frontend/src/routing/router.dart';

/// The application main class that instantiates
/// Controllers, Server, Router...
class Application {
  Router _router;

  /// Creates a new Application instance.
  Application() {
    final httpRequester = HttpRequester();
    final httpClient = HttpClient('http://localhost:8082', httpRequester);
    final homeController = HomeController(httpClient);
    final blogPostFactory = BlogPostFactory();
    final postViewController = PostViewController(httpClient);
    final postEditionController =
        PostEditionController(blogPostFactory, httpClient, postViewController);
    postViewController.postEditionController = postEditionController;
    _router = Router.createDefault()
      ..addController(homeController)
      ..addController(postViewController)
      ..addController(postEditionController);
  }

  /// Runs the application.
  void run() {
    document.body.innerHtml = '''
      <menu id="main-menu">
        <ul>
          <li id="main-menu-home-link">
            <a href="#">Home</a>
          </li>
          <li id="main-menu-type-link">
            <a href="#type">Type</a>
          </li>
          <li id="main-menu-login-link">
            <a href="#login">Login</a>
          </li>
        </ul>
      </menu>
      <div id="output">
      </div>
    ''';
    _router.startRouting();
  }
}
