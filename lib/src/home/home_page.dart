import 'package:blog_common/blog_common.dart';


/// The home page.
abstract class HomePage {
  /// Renders the home page.
  void render(List<BlogPost> blogPosts);
}