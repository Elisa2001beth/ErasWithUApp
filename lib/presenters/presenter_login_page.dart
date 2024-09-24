import '../data/user.dart';
import '../model.dart';
import '../views/i_login_page_view.dart';

class PresenterLoginPage {
  ILoginPageView view;
  Model model;

  // constructor
  PresenterLoginPage (this.view, this.model);

  // functions
  onLoginButton(String username, String password) async {
    User? user;

    if (await model.userExists(username)){
      view.correctUser = true;
      //check password
      if (await model.checkUserPassword(username, password)){
        user = await model.getUser(username);
      }
      else{
        view.correctPassword = false;
      }
    }
    else {
      view.correctUser = false;
      view.correctPassword = true;  //we do not want to warn about a password for a non-existing user
    }

    //if we get a user, go to next page
    if (user != null) {
      view.toUniversityPage(user!);
    }

    view.warnUILoginData();
  }

  void onEnterAsGuest() {
    User guest = User.getGuestUser();
    view.toUniversityPage(guest);
  }
}