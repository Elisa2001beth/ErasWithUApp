import 'dart:io';

import 'package:eraswithu/Screens/profile_screen.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/data/user_preferences.dart';
import 'package:eraswithu/model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState(user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User user;
  _EditProfilePageState(this.user);

  UserProfile? userProfile;

  late String auxName = user.profileData != null ? user.profileData!.name : '';
  late String auxCity = user.profileData != null ? user.profileData!.city : '';
  ProfileWidget? auxImagePath;
  late String auxUniversity =
      user.profileData != null ? user.profileData!.university : '';
  late String auxAbout =
      user.profileData != null ? user.profileData!.about : '';

  late Model model = Model();

  late File? imageToSave = null;

  @override
  void initState() {
    super.initState();

    userProfile = user.profileData ?? UserPreferences.getUser();
    if (user.profileData != null) {
      print(user.profileData!.name);
    } else {
      print("Algo va mal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildContainer(),
          Container(
            padding: const EdgeInsets.only(top: 150),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  showingItself: true,
                  imagePath: userProfile!.imagePath,
                  isEdit: true,
                  onClicked: () async {
                    final image = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (image == null) return;

                    final directory = await getApplicationDocumentsDirectory();
                    final name = basename(image.path);
                    final imageFile = File('${directory.path}/$name');
                    final newImage =
                        await File(image.path).copy(imageFile.path);
                    imageToSave = newImage;

                    setState(() => userProfile =
                        userProfile!.copy(imagePath: newImage.path));
                  },
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  color: const Color(0xff0077b6),
                  label: 'Full Name',
                  text: userProfile!.name,
                  onChanged: (name) => auxName = name,
                ),
                const SizedBox(height: 24),

                //esto no tiene que ser que se pueda cambiar por texto si no por seleccion como la universidad
                /*TextFieldWidget(
                  label: 'City',
                  text: userProfile!.city,
                  onChanged: (city) => auxCity = city,
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'University',
                  text: userProfile!.university,
                  onChanged: (university) => auxUniversity = university,
                ),*/

                const SizedBox(height: 24),
                TextFieldWidget(
                  color: const Color(0xff0077b6),
                  label: 'Bio',
                  text: userProfile!.about,
                  maxLines: 5,
                  onChanged: (about) => auxAbout = about,
                ),
                const SizedBox(height: 80),
                ButtonWidget(
                  text: 'Save',
                  onClicked: () async {
                    await saveUserProfileData();
                    UserPreferences.setUser(userProfile!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(user: user)));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainer() => Column(
        children: <Widget>[
          SizedBox(
            height: 270,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                      height: 240 * 15, color: const Color(0xff0077b6)),
                ),
              ],
            ),
          )
        ],
      );

  Future<void> saveUserProfileData() async {
    // crear objeto ProfileData
    UserProfile auxData = UserProfile(
      name: auxName,
      imagePath: userProfile!.imagePath,
      about: auxAbout,
      city: auxCity,
      university: auxUniversity,
    );

    if (imageToSave != null) {
      //upload file
      print("funciona");
      final path = 'images/(${imageToSave!}';
      final file = File(imageToSave!.path);

      final ref = model.getGeneralImgPath(path);
      var uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() => null);
      final urlDownload = await snapshot.ref.getDownloadURL();

      auxData = UserProfile(
          name: auxData.name,
          imagePath: urlDownload,
          about: auxData.about,
          city: auxData.city,
          university: auxData.university);
    }

    //asignar objeto ProfileData a user.profileData
    user.profileData = auxData;

    await model.updateFirebaseUser(user);
    setState(() {});
  }
}

class TextFieldWidget extends StatefulWidget {
  final String label;
  final int maxLines;
  final String text;
  final Color color;

  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.color,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  String getText() {
    return text;
  }

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xff0077b6)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
          ),
        ],
      );
}
