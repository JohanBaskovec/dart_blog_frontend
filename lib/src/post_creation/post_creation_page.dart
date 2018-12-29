abstract class PostCreationPage {
  void render();

  void onTitleChange(String Function(String title) callback);

  void onContentChange(String Function(String title) callback);
}