import 'package:blog_common/blog_common.dart';
import 'package:blog_frontend/src/home/home_controller.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.dart';

void main() {
  group('run', () {
    test('should load data and render the page', () async {
      final HomePageFactoryMock homePageFactory = HomePageFactoryMock();
      final HomePageMock homePage = HomePageMock();
      when(homePageFactory.create()).thenReturn(homePage);
      final HttpClientMock client = HttpClientMock();
      final List<BlogPost> blogPosts = <BlogPost>[
        BlogPost(),
        BlogPost(),
        BlogPost()
      ];
      when(client.getArray('/posts', BlogPost.fromJson)).thenAnswer((_) async {
        return blogPosts;
      });
      final HomeController controller = HomeController(homePageFactory, client);
      await controller.run();
      verify(homePage.render(blogPosts));
    });
  });
}