import 'dart:convert';
import 'dart:html';

import 'package:blog_frontend/src/home/home_controller.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/home/home_page_factory_impl.dart';
import 'package:blog_frontend/src/http/http_client_impl.dart';
import 'package:blog_frontend/src/http/http_requester_impl.dart';
import 'package:blog_frontend/src/post_creation/post_creation_controller.dart';
import 'package:blog_frontend/src/post_creation/post_creation_page_factory_impl.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:blog_frontend/src/routing/router.dart';

/// The application main class that instantiates
/// Controllers, Server, Router...
class Application {
  Router _router;

  /// Creates a new Application instance.
  Application() {
    final homePageFactory = HomePageFactoryImpl();
    final httpRequester = HttpRequesterImpl();
    const jsonDecoder = JsonDecoder();
    final server =
        HttpClientImpl('http://localhost:8082', httpRequester, jsonDecoder);
    final homeController = HomeController(homePageFactory, server);
    final postCreationPageFactory = PostCreationPageFactoryImpl();
    final postCreationController =
        PostCreationController(postCreationPageFactory);
    _router = Router(RouteHolder([
      Route(r'^$', homeController),
      Route(r'^post-create$', postCreationController)
    ]));
  }

  /// Runs the application.
  void run() {
    document.body.innerHtml = '''
      <menu>
        <ul>
          <li>
            <a href="#">Home</a>
          </li>
          <li>
            Type
          </li>
          <li>
            Login
          </li>
        </ul>
      </menu>
      <div id="output">
      </div>
    ''';
    window.onHashChange.listen((Event event) {
      _router.routeToHash(window.location.hash);
    });
    _router.routeToHash(window.location.hash);
  }
}
