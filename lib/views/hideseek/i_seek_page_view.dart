abstract class ISeekPageView {
  late String hint1, hint2, hint3;

  /// returns the eventID
  String getEventID();

  /// show a snackBar with a message [s]
  void showSnackBar(String s);
}