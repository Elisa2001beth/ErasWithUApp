import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';

abstract class IUniversityPageView {
  /// Changes to the MyEvents page
  toEventsPage(User user, City city){}

  ///warnUI
  bool warnUIEmptyData();

  /// Changes to Add University page
  void toAddUniPage();
}