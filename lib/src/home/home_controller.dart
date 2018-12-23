import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/home/home_page.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/server.dart';

/// The home page's controller.
class HomeController extends Controller {
  HomePageFactory _homePageFactory;
  HttpClient _server;

  /// Creates a new HomeController.
  HomeController(this._homePageFactory, this._server);

  /// Renders the page.
  @override
  void run() {
    final HomePage homePage = _homePageFactory.create();
    homePage.render();
  }
}
