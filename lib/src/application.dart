import 'dart:convert';
import 'dart:html';

import 'package:blog_frontend/src/home/home_controller.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/http/http_client_impl.dart';
import 'package:blog_frontend/src/http/http_requester.dart';
import 'package:blog_frontend/src/http/http_requester_impl.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:blog_frontend/src/routing/router.dart';

/// The application main class that instantiates
/// Controllers, Server, Router...
class Application {
  Router _router;

  /// Creates a new Application instance.
  Application() {
    final HomePageFactory homePageFactory = HomePageFactory();
    final HttpRequester httpRequester = HttpRequesterImpl();
    const JsonDecoder jsonDecoder = JsonDecoder();
    final HttpClientImpl server =
        HttpClientImpl('http://localhost:8082', httpRequester, jsonDecoder);
    final HomeController homeController =
        HomeController(homePageFactory, server);
    _router = Router(RouteHolder(<Route>[Route('', homeController)]));
  }

  /// Runs the application.
  void run() {
    window.onHashChange.listen((Event event) {
      _router.routeToHash(window.location.hash);
    });
    _router.routeToHash(window.location.hash);
  }
}
