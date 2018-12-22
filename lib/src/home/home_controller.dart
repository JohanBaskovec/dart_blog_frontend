import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';

class HomeController extends Controller {
  HomePageFactory _homePageFactory;
  HomeController(this._homePageFactory);

  @override
  void run() {
    var homePage = _homePageFactory.create();
    homePage.render();
  }
}
