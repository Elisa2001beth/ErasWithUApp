import 'dart:ui';

import 'package:eraswithu/Screens/university.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/views/events_main.dart';
import 'package:eraswithu/presenters/presenter_login_page.dart';
import 'package:eraswithu/views/i_login_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../model.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> implements ILoginPageView {

  late PresenterLoginPage presenter;

  @override
  late bool correctUser;
  @override
  late bool correctPassword;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _userKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  @override void initState() {
    super.initState();
    presenter = PresenterLoginPage(this, Model());

    correctUser = true;
    correctPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 100),
                    child: SvgPicture.asset("assets/logowithsub.svg"),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top:100, bottom:10),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0077B6)),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'With Login, Create new Events, Listings and Reply !',
                        style: TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            color: Color(0xff0077B6)),
                      )),

                  Form(
                      key: _userKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (!correctUser) {
                              return "Couldn't find your Account";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),

                            labelText: 'User Name',
                            //hintText: 'Enter valid mail id as abc@gmail.com',
                          ),
                        ),
                      ),
                  ),
                  Form(
                      key: _passwordKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (!correctPassword) {
                              return "Incorrect password";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xff0077B6), width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: 'Password',
                            //hintText: 'Enter your secure password'
                          ),
                        ),
                      ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0077B6),
                          minimumSize: const Size(100, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: onLoginButtonPressed,
                      child: const Text('Proceed'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, // the thickness
                              color: Color(0xff0077B6) // the color of the border
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: onEnterAsGuest,
                      child: const Text('Enter as Guest', style: TextStyle(
                          color: Color(0xff0077B6))),
                    ),
                  ),


                  // Province Dropdown Ends here
                ],
              ),
            )));
  }

  Future<void> onLoginButtonPressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await presenter.onLoginButton(usernameController.text, passwordController.text);
  }

  void onEnterAsGuest(){
    presenter.onEnterAsGuest();
  }
  
  //region ViewFunctions
  @override
  void toUniversityPage(User user) {
    print("To next Screen with user: ${user.userID}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUniversity(user: user)
        )
    );
  }

  @override
  void warnUILoginData() {
    _userKey.currentState!.validate();
    _passwordKey.currentState!.validate();
  }
  //endregion
}
