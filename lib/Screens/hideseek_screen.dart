import 'package:eraswithu/Screens/seek_screen.dart';
import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/hideseek/presenter_hideseek_page.dart';
import 'package:eraswithu/views/hideseek/i_hideseek_page_view.dart';
import 'package:flutter/material.dart';

import '../data/user.dart';
import 'hide_screen.dart';


class HideAndSeek extends StatefulWidget {
  const HideAndSeek({super.key, required this.user, required this.eventID});

  final User user;
  final String eventID;

  @override
  State<StatefulWidget> createState() => _HideAndSeek(user, eventID);
}

class _HideAndSeek extends State<HideAndSeek> implements IHideSeekPageView {

  static const String _title = 'Hide&Seek';

  final User user;
  final String eventID;
  _HideAndSeek(this.user, this.eventID);

  @override
  late bool fadeSeekButton = false;

  late PresenterHideSeekPage presenter;

  @override
  void initState() {
    super.initState();
    presenter = PresenterHideSeekPage(this, Model());
    Future.delayed(Duration.zero,() async {
      //your async 'await' codes goes here
      await presenter.checkFadeVisibilty();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // 1
          elevation: 0, // 2
          title: const Text(''),
          ),
          body: Center(

          child: SelectionArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: const Text('Hide & Seek', style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0077B6))),
                  ),
                  const SizedBox(height: 20),
                  const Text('Want to meet new\npeople at events?', style: TextStyle(
                      fontFamily: 'Karla',
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      color: Color(0xff0077B6)),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: onHideButtonPressed, // Image tapped
                    splashColor: Colors.white10, // Splash color over image
                    child: Ink.image(
                      //fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 160,
                      image: const AssetImage('assets/Hide.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Container(
                  //
                  //   padding: const EdgeInsets.only(left: 20, right: 20),
                  //   child: Image.asset('assets/Seek.png'),
                  // ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: onSeekButtonPressed, // Image tapped
                    splashColor: Colors.white10, // Splash color over image
                    child: Ink.image(
                      //fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 150,
                      image: const AssetImage('assets/Seek.png'),
                      child: Visibility(
                        visible: fadeSeekButton,
                        child: const Material(
                          color: Color(0xaaafafaf),
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text('This is a new way of finding new friends, just look for them or let others find you.', style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18,
                        //fontWeight: FontWeight.bold,
                        color: Color(0xff0077B6)),
                    ),
                  ),
                ],
              )


            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const <Widget>[
            //     Text('HideAndSeek'),
            //   ],
            // ),
          ),
        ),
      );
  }

  void onHideButtonPressed() {
    presenter.onHideButtonPressed();
  }

  Future<void> onSeekButtonPressed() async {
    await presenter.onSeekButtonPressed();
  }

  //region ViewFunctions
  @override
  String getEventID() {
    return eventID;
  }

  @override
  void toHidePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Hide(user: user, eventID: eventID,)),
    );
  }

  @override
  void toSeekPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Seek(user: user, eventID: eventID,)),
    );
  }

  @override
  void showSnackBar(String msg) {
    //TODO: I do not know why it is not working
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,style: const TextStyle(fontFamily: 'Karla', fontSize: 16) ),
      ),
    );
  }
  //endregion
}
