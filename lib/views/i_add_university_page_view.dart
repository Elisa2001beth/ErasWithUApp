abstract class IAddUniPageView {
  late bool writingCity;
  late bool cityExists;

  /// show/hide the things to change the mode
  void changeVisibilities();

  /// warns the user's empty fields
  bool warnUI();

  /// change to events page
  void toEventsPage();
}