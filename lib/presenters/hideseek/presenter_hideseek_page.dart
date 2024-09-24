import 'package:eraswithu/model.dart';
import 'package:eraswithu/views/hideseek/i_hideseek_page_view.dart';

class PresenterHideSeekPage {
  final IHideSeekPageView view;
  final Model model;

  PresenterHideSeekPage(this.view, this.model);

  Future<void> checkFadeVisibilty() async {
    var usersHidden = await model.getAllUsersHidden(view.getEventID());
    if (usersHidden.isEmpty){
      //put the grey color
      view.fadeSeekButton = true;
    }
    else {
      //remove the grey color
      view.fadeSeekButton = false;
    }
    print("dentro");
    print(view.fadeSeekButton);
  }

  void onHideButtonPressed() {
    view.toHidePage();
  }

  Future<void> onSeekButtonPressed() async {
    var usersHidden = await model.getAllUsersHidden(view.getEventID());
    if (usersHidden.isEmpty){
      view.showSnackBar('No users hidden yet');
    }
    else{
      view.toSeekPage();
    }
  }
}