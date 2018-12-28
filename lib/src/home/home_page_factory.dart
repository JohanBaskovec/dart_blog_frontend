import 'package:blog_frontend/src/generic_factory.dart';
import 'package:blog_frontend/src/home/home_page.dart';

/// Used to create new instances of [HomePage].
/// This interface is necessary because it doesn't depend
/// on dart:html and can be used in unit tests without running the browser.
abstract class HomePageFactory implements GenericFactory<HomePage> {}