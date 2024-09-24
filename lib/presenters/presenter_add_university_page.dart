import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/presenter_university_page.dart';
import 'package:eraswithu/views/i_add_university_page_view.dart';

class PresenterAddUniversityPage{
  IAddUniPageView view;
  Model model;

  PresenterAddUniversityPage(this.view, this.model);

  Future<List<City>> getAllCities() async {
    return await model.getAllCities();
  }

  City? getCityByName(String city) {
    return model.getCityByName(city);
  }

  void onAnotherCityButton() {
    view.changeVisibilities();
  }

  Future<void> onAddUni(City? selectedCity, String cityWrite, String universityName, User user) async {
    if (!view.warnUI()){
      return;
    }

    UserProfile userProfile;
    if (!view.writingCity){ //selected city
      userProfile = PresenterUniversityPage.getNewUserProfile(user, selectedCity!.name, universityName);
      await model.addUniToCity(selectedCity!.name, universityName);
    }
    else {  //written city
      userProfile = PresenterUniversityPage.getNewUserProfile(user, cityWrite, universityName);
      City? cityAdded = await model.addCity(cityWrite, universityName);
      if (cityAdded == null){
        view.cityExists = true;
        view.warnUI();
        return;
      }
      else {
        view.cityExists = false;
      }
    }
    user.profileData = userProfile;

    view.toEventsPage();
  }
}