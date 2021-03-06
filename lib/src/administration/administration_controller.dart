import 'dart:html';

import 'package:blog_frontend/src/controller.dart';
import 'package:blog_frontend/src/dom.dart';

class AdministrationController extends Controller {
  @override
  String get hash => 'administration';

  @override
  Future<void> run() async {
    final DivElement root = byId('output');
    root.innerHtml = '''
    <ul>
      <li><a href="#book-edition">Add a book</a></li>
      <li><a href="#text-creation">Add a single text</a></li>
    </ul>
    ''';
  }
}
