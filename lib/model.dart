

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/city.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/presenters/presenter_university_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class UserHints {
  final User user;
  final String hint1;
  final String hint2;
  final String hint3;

  UserHints(this.user, this.hint1, this.hint2, this.hint3);

  @override
  String toString() {
    return "${user.userID}: $hint1, $hint2, $hint3";
  }
}

/// Singleton class
class Model {

  static final Model _instance = Model._privateConstructor();

  factory Model() {
    return _instance;
  }

  Model._privateConstructor();

  //Database database;
  /// TODO: debug only
  List<String> database = ["Isabel", "Adri", "Thamas", "Akhil", "Nico", "David"];
  List<String> databasePasswords = ["1234", "5678", "9012", "3456","1234", "2345"];
  List<City> citiesInLocal = [
    City("Bremen",
        [
          'Universität Bremen',
          'HSB Hochschule Bremen',
          'Hochschule für Künste Bremen'
        ]
    ),
    City("Berlin",
        ['Technische Universität Berlin']
    ),
    City("Hamburg",
        [
          'Universität Hamburg',
          'Technische Universität Hamburg',
        ]
    ),
    City("Stuttgart",
        [
          'Universität Stuttgart',
          'Hochschule für Technik Stuttgart',
        ]
    ),
    City("Palencia", //extra testing city, works
        ["UVA"]
    )
  ];

  Map<String, List<UserHints>> usersHiddenInEvents = <String, List<UserHints>>{};

  //region FirebaseReferences
  final usersRef = FirebaseFirestore.instance.collection('User');
  final citiesRef = FirebaseFirestore.instance.collection('City');
  final eventsRef = FirebaseFirestore.instance.collection('Event');
  static const PASSWORD = 'password';
  static const PROFILE_ABOUT = 'profileAbout';
  static const PROFILE_CITY = 'profileCity';
  static const PROFILE_IMG_PATH = 'profileImgPath';
  static const PROFILE_NAME = 'profileName';
  static const PROFILE_UNIVERSITY = 'profileUniversity';
  static const UNIVERSITIES = 'Universities';
  static const IMGS_IN_EVENT = 'imgsInEvent';
  static const IMG_PATH = 'imgPath';
  static const HIDDEN_USERS = 'hiddenUsers';
  static const HINT1 = 'hint1';
  static const HINT2 = 'hint2';
  static const HINT3 = 'hint3';
  //endregion

  /// Call the database and check if [userID] exists
  Future<bool> userExists(String userID) async {

    bool exists = false;
    await usersRef.doc(userID).get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            exists = true;
          }
      });

    return exists;

    // if (database.contains(userID))
    //   return true;
    //
    // return false;
  }

  /// Call the database and check if [userID] has [password] as password
  ///
  /// We assume that [userID] exists
  Future<bool> checkUserPassword(String userID, String password) async {

    bool correctPassword = false;
    var user = await usersRef.doc(userID).get();
    if (user.data()![PASSWORD] == password){
      correctPassword = true;
    }

    return correctPassword;

    // //obtain real userPassword
    // String userPassword = databasePasswords[database.indexOf(username)];
    //
    // //check if it is the correct password
    // if (password == userPassword){
    //   return true;
    // }
    // return false;
  }

  /// Returns the User with [userID]
  /// We assume that [userID] exists
  Future<User> getUser(String userID) async {
    User user = User(userID);

    var userInDB = await usersRef.doc(userID).get();
    var data = userInDB.data();

    UserProfile userProfile = UserProfile(
        name: data![PROFILE_NAME],
        imagePath: data![PROFILE_IMG_PATH],
        about: data![PROFILE_ABOUT],
        city: data![PROFILE_CITY],
        university: data![PROFILE_UNIVERSITY]
    );

    user.profileData = userProfile;
    user.profileData = PresenterUniversityPage.getNewUserProfile(user, userProfile.city, userProfile.university);

    return user;
  }

  /// Save user in the database
  void saveUserInDB(User user) {
    // TODO
  }

  Future<void> updateFirebaseUser(User user) async {
    final userRef = usersRef.doc(user.userID);


    await userRef.update({
      PROFILE_ABOUT: user.profileData!.about,
      PROFILE_CITY: user.profileData!.city,
      PROFILE_IMG_PATH: user.profileData!.imagePath,
      PROFILE_NAME: user.profileData!.name,
      PROFILE_UNIVERSITY: user.profileData!.university
    });
  }

  /// get cities from database
  Future<List<City>> getAllCities() async {

    List<City> citiesInDB = [];

    var querySnapshot = await citiesRef.get();
    for (final city in querySnapshot.docs){
      var unisInCity = citiesRef.doc(city.id).collection(UNIVERSITIES);
      var snapshot = await unisInCity.get();

      List<String> universities = [];
      for (final university in snapshot.docs){
        universities.add(university.id);
      }

      citiesInDB.add(City(city.id, universities));
    }

    citiesInLocal = citiesInDB; //to avoid innecesary callings
    return citiesInDB;
  }

  /// get city using the local list
  City? getCityByName(String city) {
    for (City c in citiesInLocal) {
      if (c.name == city)
        return c;
    }

    return null;
  }

  /// add a university into the database
  /// returns true if it was possible
  /// otherwise false
  Future<bool> addUniToCity(String cityID, String universityName) async {
    CollectionReference unisRef = citiesRef.doc(cityID).collection(UNIVERSITIES);
    Map<String, dynamic> universityData = {};

    await unisRef.doc(universityName).set(universityData);

    return true;
  }

  /// add a city to the database
  /// returns the new City
  Future<City?> addCity(String cityName, String universityName) async {
    // Comprobar si ya existe una ciudad con ese ID
    var citySnapshot = await citiesRef.doc(cityName).get();

    // return null if the city exists
    if (citySnapshot.exists) {
      return null;
    }

    //add city
    await citiesRef.doc(cityName).set({});
    //add uni
    var unisRef = citiesRef.doc(cityName).collection(UNIVERSITIES);
    await unisRef.doc(universityName).set({});

    //add in local
    City newCity = City(cityName, [universityName]);
    citiesInLocal.add(newCity);

    return newCity;
  }

  /// get all users hidden in an event
  /// if the eventID doesn't exist, it returns null
  Future<List<UserHints>> getAllUsersHidden(String eventID) async {

    List<UserHints> usersHidden = [];

    var hiddenUsers = eventsRef.doc(eventID).collection(HIDDEN_USERS);
    var snapshot = await hiddenUsers.get();

    for (final hiddenUser in snapshot.docs) {
      bool exists = await userExists(hiddenUser.id);
      if (!exists) {
        continue;
      }

      usersHidden.add(UserHints(
              User(hiddenUser.id),
              hiddenUser.data()![HINT1],
              hiddenUser.data()![HINT2],
              hiddenUser.data()![HINT3])
          );
    }

    return usersHidden;
  }

  /// returns a randome user hidden
  /// must be called if we are sure that the eventID exists
  Future<UserHints> getSomeUserHintsFromEvent(String eventID) async {
    List<UserHints> usersHidden = await getAllUsersHidden(eventID);

    //choose randome to show
    final random = Random();

    return usersHidden[random.nextInt(usersHidden.length)];
  }

  /// saves user hidden in an event
  Future<void> saveHiddenUser(String eventID, User user, String hint1, String hint2, String hint3) async {
    await eventsRef.doc(eventID).collection(HIDDEN_USERS).doc(user.userID).set({
      HINT1: hint1,
      HINT2: hint2,
      HINT3: hint3
      })
      .then((value) => print("Elemento añadido"))
      .catchError((error) => print("Error al añadir elemento: $error"));

  }

  /// saves img in an event
  Future<void> uploadPeopleInEventImg(String eventID, String path) async {

    eventsRef.doc(eventID).collection(IMGS_IN_EVENT).add({
      IMG_PATH: path
    });

  }

  /// returns all the imgsPath of the imgs saved in an event
  Future<List<String>> getImgsInEvent(String eventID) async {
    List<String> imgsPaths = [];

    final imgsInEvensRef = eventsRef.doc(eventID).collection(IMGS_IN_EVENT);
    imgsInEvensRef.snapshots().listen((querySnapshot){
      querySnapshot.docs.forEach((documentSnapshot) {
        print(documentSnapshot);
        imgsPaths.add(documentSnapshot.data()[IMG_PATH]);
      });
    });

    await Future.delayed(Duration(milliseconds: 200));

    return imgsPaths;
  }

  Future<PickedFile?> getImageFromUser() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    return image;
  }

  Future<FilePickerResult?> selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    return result;
  }

  // Future<String> uploadImage(File image) async {
  //   final storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('images/${DateTime.now().toIso8601String()}.jpg');
  //   final UploadTask uploadTask = storageReference.putFile(image);
  //   String downloadURL = '';
  //   await uploadTask.then((value) async {
  //     downloadURL = await value.ref.getDownloadURL();
  //   });
  //
  //   return downloadURL;
  // }


  Future<Directory> getAppDocsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  getBasename(String path) {
    final name = basename(path);
    return name;
  }

  Reference getGeneralImgPath(String path) {
    return FirebaseStorage.instance.ref().child(path);
  }
}