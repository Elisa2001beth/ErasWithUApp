import 'package:eraswithu/model.dart';
import 'package:eraswithu/views/hideseek/i_hide_page_view.dart';

class PresenterHidePage {
  final IHidePageView view;
  final Model model;

  PresenterHidePage(this.view, this.model);

  Future<void> onHideButtonPressed(String hint1, String hint2, String hint3) async {
    if (!view.allHintsInputted()){
      return;
    }

    await model.saveHiddenUser(view.getEventID(), view.getUser(), hint1, hint2, hint3);

    view.confirmHiddenUser();
    view.toHideSeekPage();
  }
}