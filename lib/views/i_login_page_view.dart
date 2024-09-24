
import 'package:eraswithu/data/user.dart';

abstract class ILoginPageView {
  late bool correctUser;
  late bool correctPassword;

  /// Changes to the UniversitySelection Page
  void toUniversityPage(User user) {}

  /// Do UI magic to warn the user about a wrong password
  void warnUILoginData() {}

}