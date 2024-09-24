import 'dart:io';

import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/userProfile.dart';
import 'package:eraswithu/data/user_preferences.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user, this.userToShow});

  final User user;
  final User? userToShow;

  static bool notGuest(String userID, var context) {
    if (userID == "Guest") {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              //backgroundColor: Color(0xffDFEFF2),
              //contentPadding: EdgeInsets.zero,
              title: const Text('Login Needed'),
              content: const Text(
                  'You need to Login in order to see other profiles.',
                  style: TextStyle(
                      fontFamily: 'Karla', color: Color(0xff0077B6)))));
      return false;
    }
    return true;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState(user, userToShow);
}

//CLASS PROFILE PAGE THAT CONTAINS THE WIDGET WITH ALL INSIDE FOR THE PROFILE SCREEN

class _ProfilePageState extends State<ProfilePage> {
  final User user;
  late User? userToShow;

  _ProfilePageState(this.user, this.userToShow);

  bool showingItself = false;

  @override
  void initState() {
    super.initState();
    if (userToShow == null) {
      userToShow = user;
      showingItself = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = userToShow!.profileData != null
        ? userToShow!.profileData!
        : UserPreferences.getUser();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildContainer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      //color: Color(0xff0077b6),
                      color: Color(0xff0077b6),
                      fontFamily: 'Rubik'),
                ),
                const SizedBox(height: 24),
                ProfileWidget(
                  showingItself: showingItself,
                  imagePath: userProfile.imagePath,
                  onClicked: () {
                    if (!showingItself) {
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user)),
                    );
                    setState(() {});
                  },
                ),
                //name of the user
                const SizedBox(height: 24),
                buildName(userProfile),
                const SizedBox(height: 24),
                buildCity(userProfile),
                const SizedBox(height: 40),
                buildUniversity(userProfile),
                const SizedBox(height: 40),
                buildAbout(userProfile),
                const SizedBox(height: 24),
                Center(
                    child: Visibility(
                  visible: showingItself,
                  child: buildLogOutButton(),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //THIS WIDGET CREATE THE FORM OF THE CURVE AT THE BOTTOM

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

  //THIS WIDGET CREATE THE NAME OF THE USER

  Widget buildName(UserProfile userProfile) => Column(
        children: [
          Text(
            userProfile.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xff0077b6),
                fontFamily: 'Rubik'),
          ),
          const SizedBox(height: 4),
        ],
      );

  //THIS WIDGET CREATE THE LOG OUT BOTTOM

  Widget buildLogOutButton() => ButtonWidget(
        text: 'Log Out',
        onClicked: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MyLogin()),
          // );
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      );

  //THIS WIDGET CREATE THE CITY OF THE USER

  Widget buildCity(UserProfile userProfile) => Row(
        children: [
          const Icon(Icons.business, color: Color(0xff0077b6), size: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  userProfile.city,
                  style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0077b6),
                      fontFamily: 'Karla'),
                ),
              ],
            ),
          ),
        ],
      );

  //THIS WIDGET CREATE THE UNIVERSITY OF THE USER
  Widget buildUniversity(UserProfile userProfile) => Row(
        children: [
          const Icon(Icons.account_balance, color: Color(0xff0077b6), size: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Container(
                  width: 300,
                  child: Text(
                    userProfile.university,
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0077b6),
                        fontFamily: 'Karla'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  //THIS WIDGET CREATE THE ABOUT OF THE USER

  Widget buildAbout(UserProfile userProfile) => Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Color(0xff0077b6), size: 32),
              Container(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Bio:',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0077b6),
                        fontFamily: 'Karla'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Container(
                  width: 300,
                  child: Text(
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    userProfile.about,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff0077b6),
                        fontFamily: 'Karla'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

//THIS CLASS CREATE THE IMAGE OF THE USER AND THE BOTTOM FOR EDIT THE PROFILE PAGE

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;
  final bool showingItself;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false, required this.showingItself,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Visibility(
            visible: showingItself,
            child: Positioned(bottom: 0, right: 4, child: buildEditIcon(color)),
          ),
        ],
      ),
    );
  }

  //THIS WIDGET CREATE THE IMAGE OF THE USER

  Widget buildImage() {
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  //THIS WIDGET CREATE THE ICON FOR EDIT THE PROFILE PAGE

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: const Color(0xff0077b6),
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0077b6),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: onClicked,
        child: Text(text),
      );
}

//THIS WIDGET CREATE THE SHAPE OF THE CONTAINER

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
