import 'dart:convert';
import 'dart:html';

import 'package:blog_frontend/src/home/home_controller.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/http_requester_impl.dart';
import 'package:blog_frontend/src/json_server.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:blog_frontend/src/routing/router.dart';

class Application {
  Router router;

  Application() {
    final homePageFactory = HomePageFactory();
    final httpRequester = HttpRequesterImpl();
    final jsonDecoder = JsonDecoder();
    final server = JsonServer("http://localhost:8082", httpRequester, jsonDecoder);
    final homeController = HomeController(homePageFactory, server);
    final RouteHolder routes = RouteHolder([Route("", homeController)]);
    router = Router(routes);
    window.onHashChange.listen((event) {
      router.routeToHash(window.location.hash);
    });
  }

  run() {
    router.routeToHash(window.location.hash);
  }
}
