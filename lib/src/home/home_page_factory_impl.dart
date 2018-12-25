import 'package:blog_frontend/src/home/home_page.dart';
import 'package:blog_frontend/src/home/home_page_factory.dart';
import 'package:blog_frontend/src/home/home_page_impl.dart';

/// Used to create a new instance of a HomePage.
class HomePageFactoryImpl implements HomePageFactory {
  /// Creates a new instance of HomePage.
  @override
  HomePage create() {
    return HomePageImpl();
  }
}
