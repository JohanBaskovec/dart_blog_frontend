import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/home/home_page.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/http/http_client.dart';
import 'package:blog_frontend/src/routing/routing_context.dart';

/// The home page's controller.
class HomeController extends Controller {
  HomePageFactory _homePageFactory;
  HttpClient _httpClient;

  /// Creates a new HomeController.
  HomeController(this._homePageFactory, this._httpClient);

  /// Renders the page.
  @override
  Future<void> run() async {
    final List<BlogPost> blogPosts =
        await _httpClient.getArray('/posts', BlogPost.fromJson);
    final HomePage homePage = _homePageFactory.create();
    homePage.render(blogPosts);
  }
}
