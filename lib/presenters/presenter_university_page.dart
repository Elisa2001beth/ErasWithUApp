import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/data/user_preferences.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/views/i_university_page_view.dart';

class PresenterUniversityPage {
  IUniversityPageView view;
  Model model;

  PresenterUniversityPage(this.view, this.model);

  void onProceedClicked(City? city, String? universityName, User user) {
    if (!view.warnUIEmptyData()) return;

    UserProfile userProfile = getNewUserProfile(user, city!.name, universityName!);
    // if (user.profileData != null) {
    //   userProfile = UserProfile(
    //       name: user.profileData!.name,
    //       imagePath: user.profileData!.imagePath,
    //       about: user.profileData!.about,
    //       city: city!.name,
    //       university: universityName!);
    // } else {
    //   userProfile = UserProfile(
    //       name: user.name,
    //       imagePath: UserPreferences.getUser().imagePath,
    //       about: UserPreferences.getUser().about,
    //       city: city!.name,
    //       university: universityName!);
    // }
    user.profileData = userProfile;

    view.toEventsPage(user, city);
  }

  Future<List<City>> getAllCities() {
    return model.getAllCities();
  }

  City? getCityByName(String city) {
    return model.getCityByName(city);
  }

  void onAddUniButton() {
    view.toAddUniPage();
  }
  
  static UserProfile getNewUserProfile(User user, String city, String universityName){
    UserProfile userProfile;
    if (user.profileData != null) {
      userProfile = UserProfile(
          name: user.profileData!.name.isEmpty ? user.userID : user.profileData!.name,
          imagePath: user.profileData!.imagePath.isEmpty ? UserPreferences.getUser().imagePath : user.profileData!.imagePath,
          about: user.profileData!.about.isEmpty ? UserPreferences.getUser().about : user.profileData!.about,
          city: city,
          university: universityName);
    }
    else {
      userProfile = UserProfile(
          name: user.userID,
          imagePath: UserPreferences.getUser().imagePath,
          about: UserPreferences.getUser().about,
          city: city,
          university: universityName);
    }
    
    return userProfile;
  }
}
