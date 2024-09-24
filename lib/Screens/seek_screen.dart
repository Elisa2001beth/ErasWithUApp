import 'package:eraswithu/model.dart';
import 'package:eraswithu/presenters/hideseek/presenter_seek_page.dart';
import 'package:eraswithu/views/hideseek/i_seek_page_view.dart';
import 'package:flutter/material.dart';
import '../presenters/custom_appbar.dart';
import '../data/user.dart';

class Seek extends StatefulWidget {
  const Seek({super.key, required this.user, required this.eventID});

  final User user;
  final String eventID;

  @override
  State<StatefulWidget> createState() => _SeekState(user, eventID);
}

class _SeekState extends State<Seek> implements ISeekPageView {

  static const String _title = 'Seek';

  final User user;
  final String eventID;
  _SeekState(this.user, this.eventID);

  late PresenterSeekPage presenter;

  @override
  late String hint1 = '';
  @override
  late String hint2 = '';
  @override
  late String hint3 = '';

  @override
  void initState() {
    super.initState();
    presenter = PresenterSeekPage(this, Model());
    Future.delayed(Duration.zero,() async {
      //your async 'await' codes goes here
      await presenter.getHints(eventID);
      setState(() {});
    });
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
                      image: const AssetImage('assets/Seek.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      'Find the person with below details:',
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Color(0xff000000)),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        hint1,
                        style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Color(0xff000000)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        hint2,
                        style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Color(0xff000000)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        hint3,
                        style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Color(0xff000000)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: const Text(
                      'Upload memories to remember this new friendship. ',
                      style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                          color: Color(0xff000000)),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffADDEDC),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                    onPressed: () async {
                      await onUploadImageButton();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Upload Image',
                          style: TextStyle(
                              fontFamily: 'Karla',
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                              color: Color(0xff000000))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  /*Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, // the thickness
                              color: Color(0xffADDEDC) // the color of the border
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: (){},
                      child: const Text('Quit Game', style: TextStyle(
                          color: Color(0xffADDEDC))),
                    ),
                  ),*/
                ],),


            )

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: const <Widget>[
          //     Text('Hide'),
          //   ],
          // ),
        ),
      );
  }

  Future<void> onUploadImageButton() async {
    await presenter.onUploadImageButton();
  }

  //region ViewFunctions
  @override
  String getEventID() {
    return eventID;
  }

  @override
  void showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }
  //endregion
}
