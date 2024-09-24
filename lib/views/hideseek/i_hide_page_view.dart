
import 'package:eraswithu/data/user.dart';

abstract class IHidePageView {
  /// check if the TextFormField are fielded
  bool allHintsInputted();

  /// returns the ID of the current event for the hideandseek
  String getEventID();

  /// returns the actual User
  User getUser();

  /// returns to the previous page, the HideSeek
  void toHideSeekPage();

  /// saw a message to the user
  void confirmHiddenUser();
}