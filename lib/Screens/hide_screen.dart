import 'package:eraswithu/Screens/hideseek_screen.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/hideseek/presenter_hide_page.dart';
import 'package:eraswithu/views/hideseek/i_hide_page_view.dart';
import 'package:flutter/material.dart';
import '../data/user.dart';

class Hide extends StatefulWidget {
  const Hide({super.key, required this.user, required this.eventID});

  final User user;
  final String eventID;

  @override
  State<StatefulWidget> createState() => _HideState(user, eventID);
}

class _HideState extends State<Hide> implements IHidePageView {

  static const String _title = 'Seek';

  final User user;
  final String eventID;

  _HideState(this.user, this.eventID);

  late PresenterHidePage presenter;

  final firstHintController = TextEditingController();
  final secondHintController = TextEditingController();
  final thirdHintController = TextEditingController();

  final _firstHintKey = GlobalKey<FormState>();
  final _secondHintKey = GlobalKey<FormState>();
  final _thirdHintKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    presenter = PresenterHidePage(this, Model());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 1
        elevation: 0, // 2
        title: Text(''),
      ),
        body: Center(
          child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {}, // Image tapped
                    splashColor: Colors.white10, // Splash color over image
                    child: Ink.image(
                      //fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 160,
                      image: const AssetImage('assets/Hide.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      'Add Hints to hide:',
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Color(0xff000000)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _firstHintKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: firstHintController,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "You forget the first hint";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffADE8F4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xff0077B6), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Hint 1',
                        ),
                        onChanged: (String date) {
                          // getEventDate(date);
                        },
                      ),),
                  ),
                  Form(
                    key: _secondHintKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: secondHintController,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "You forget the second hint";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffADE8F4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xff0077B6), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Hint 2',
                        ),
                        onChanged: (String date) {
                          // getEventDate(date);
                        },
                      ),
                    ),
                  ),
                  Form(
                    key: _thirdHintKey,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: thirdHintController,
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return "You forget the third hint";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffADE8F4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xff0077B6), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Hint 3',
                        ),
                        onChanged: (String date) {
                          // getEventDate(date);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffADE8F4),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                    onPressed: onHideButtonPressed,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Hide',
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                              color: Color(0xff000000))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, // the thickness
                              color: Color(0xffADE8F4) // the color of the border
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: (){},
                      child: const Text('Quit Game', style: TextStyle(
                          color: Color(0xff0077B6))),
                    ),
                  ),
                ],
              )

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const <Widget>[
            //     Text('Hide'),
            //   ],
            // ),
          ),
        ),
      );
  }

  Future<void> onHideButtonPressed() async {
    await presenter.onHideButtonPressed(firstHintController.text, secondHintController.text, thirdHintController.text);
  }

  //region ViewFunctions
  @override
  bool allHintsInputted() {
    bool b1 = _firstHintKey.currentState!.validate();
    bool b2 = _secondHintKey.currentState!.validate();
    bool b3 = _thirdHintKey.currentState!.validate();

    return b1 && b2 && b3;
  }

  @override
  String getEventID() {
    return eventID;
  }

  @override
  User getUser() {
    return user;
  }

  @override
  void toHideSeekPage() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HideAndSeek(user: user, eventID: eventID,)
      ),
    );
  }

  @override
  void confirmHiddenUser() {
    // TODO: fix it, it doesn't show
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Now you are hidden'),
      ),
    );
  }
  //endregion
}
