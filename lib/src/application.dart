import 'dart:html';

import 'package:blog_frontend/src/home/home_controller.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/routing/route.dart';
import 'package:blog_frontend/src/routing/route_holder.dart';
import 'package:blog_frontend/src/routing/router.dart';

class Application {
  Router router;

  Application() {
    final homePageFactory = HomePageFactory();
    final homeController = HomeController(homePageFactory);
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
