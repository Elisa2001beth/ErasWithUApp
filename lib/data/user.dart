import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/data/user_preferences.dart';

class User {
  String userID;
  UserProfile? profileData;

  //constructor
  User(this.userID) {
    //profileData = UserPreferences.getUser(); //default parameters
  }

  static User getGuestUser() {
    String guestName = "Guest";
    //UserProfile guestProfile = UserPreferences.getUser();

    User guest = User(guestName);
    //guest.profileData = guestProfile;

    return guest;
  }
}
