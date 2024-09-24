abstract class IHideSeekPageView {
  ///to control the seek button
  late bool fadeSeekButton;

  ///get the eventID
  String getEventID();

  ///send you to Hide Screen
  void toHidePage();

  ///send you to Seek Screen
  void toSeekPage();

  ///show a snackBar that tell the user that no one is hidden
  void showSnackBar(String msg);
}