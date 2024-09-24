import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../presenters/custom_appbar.dart';
import '../views/events_main.dart';
import '../views/listings_main.dart';
import '../views/messaging_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<Home> createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  final User user;

  _HomeState(this.user);

  final Model model = Model();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      //your async 'await' codes goes here
      await model.updateFirebaseUser(user);
      setState(() {});
    });
  }

  int index = 0;
  int _selectedIndex = 0;

  // document IDs
  List<String> docIDs = [];

  // get DocIDs
  Future getDocID() async {
    setState(() => docIDs.clear());
    await FirebaseFirestore.instance.collection('Event').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            // print('----');
            // print(docIDs.length);
            // print(document.reference);
            docIDs.add(document.reference.id);
          }),
        );
  }

  void _onItemTapped(int indexNumber) {
    setState(() {
      _selectedIndex = indexNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Do you want to Exit?'),
                  content:Image.asset(
                        'assets/exit.gif',
                        height: 125.0,
                        width: 125.0,
                      ),

                  // Container(
                  //     child: const Text('Do you want to Exit?'),
                  // ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(

                          backgroundColor: const Color(0xff0077B6),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(

                          backgroundColor: const Color(0xff0077B6),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: () => SystemNavigator.pop(),
                      child: const Text('Exit'),
                    ),
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            appBar: CustomAppBar(context: context, user: user),
            body: TabBarView(
              children: [
                Messaging(
                    user: user,
                    doc: "city",
                    subcollection: user.profileData!.city),
                MyEvents(user: user),
                MyListings(user: user)
              ],
            ),
          ),
        ));
  }
}
