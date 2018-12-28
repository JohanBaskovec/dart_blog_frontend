import 'package:blog_frontend/src/post_creation/post_creation_page.dart';
import 'package:blog_frontend/src/post_creation/post_creation_page_factory.dart';
import 'package:blog_frontend/src/post_creation/post_creation_page_impl.dart';

class PostCreationPageFactoryImpl implements PostCreationPageFactory {
  @override
  PostCreationPage create() {
    return PostCreationPageImpl();
  }
}

