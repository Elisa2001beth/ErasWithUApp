import 'dart:convert';

import 'package:eraswithu/data/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _keyUser = 'user';
  static const myUser = UserProfile(
    imagePath:
        'https://static.vecteezy.com/system/resources/previews/007/567/154/original/select-image-icon-vector.jpg',
    name: 'Introduce a name',
    city: 'Select your city',
    university: 'Select your university',
    about: 'Info about you',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserProfile user) async {
    final json = jsonEncode(user.toJson());
    await _preferences?.setString(_keyUser, json);
  }

  static UserProfile getUser() {
    final json = _preferences?.getString(_keyUser);

    return json == null ? myUser : UserProfile.fromJson(jsonDecode(json));
  }
}
