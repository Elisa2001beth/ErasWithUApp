import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/presenters/presenter_event_page.dart';
import 'package:eraswithu/views/event_details.dart';
import 'package:flutter/material.dart';

import '../Screens/add_events.dart';
import '../Screens/login_screen.dart';
import '../data/user_preferences.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyEvents> createState() => _MyEventsState(user);
}

class _MyEventsState extends State<MyEvents> {


  final User user;

  _MyEventsState(this.user);

  int index = 0;
  int _selectedIndex = 0;

  // document IDs
  List<String> docIDs = [];



  // get DocIDs
  Future getDocID() async {
    final userProfile = user.profileData != null
        ? user.profileData!
        : UserPreferences.getUser();
    setState(() => docIDs.clear());
    await FirebaseFirestore.instance.collection('Event').where("eventCity", isEqualTo: userProfile.city).get().then(
          (snapshot) => snapshot.docs.forEach((document) {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user.userID == "Guest") {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                //backgroundColor: Color(0xffDFEFF2),
                //contentPadding: EdgeInsets.zero,
                title: const Text('Login Needed'),
                content: const Text(
                    'You need to Login in order to add new events.',
                    style: TextStyle(
                        fontFamily: 'Karla', color: Color(0xff0077B6))),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            width: 2, // the thickness
                            color: Color(0xff0077B6) // the color of the border
                            ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )),
                    onPressed: () => Navigator.pop(
                      context,
                      'Cancel',
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Color(0xff0077B6))),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          //minimumSize: const Size(100, 50),
                          backgroundColor: const Color(0xff0077B6),
                          //padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyLogin()),
                        );
                      },
                      label: const Text('Login'),
                      icon: const Icon(Icons.arrow_right_alt, size: 20),
                    ),
                  ),
                ],
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvents(user: user)),
            );
          }
        },
        backgroundColor: const Color(0xff0077B6),
        //label: const Text('Add an Event'),

        child: const Icon(Icons.add),
      ),
      extendBodyBehindAppBar: false,
      //appBar: CustomAppBar(context: context, user: user),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: FutureBuilder(
            future: getDocID(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      //elevation: 10,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(8.0),
                        //margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3, color: const Color(0xff0077B6)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                        eventID: docIDs[index],
                                        user: user,
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                          GetImageData(eventID: docIDs[index]),
                                    )),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: GetEventData(eventID: docIDs[index]),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, top: 8.0),
                                  child: GetEventData2(eventID: docIDs[index]),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0, top: 8.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffADE8F4),
                                            border: Border.all(
                                              color: const Color(0xffADE8F4),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        padding: const EdgeInsets.all(12.0),
                                        child: GetEventData3(
                                            eventID: docIDs[index]),
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffADE8F4),
                                            border: Border.all(
                                              color: const Color(0xffADE8F4),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        padding: const EdgeInsets.only(
                                            right: 15,
                                            top: 12,
                                            bottom: 12,
                                            left: 12),
                                        //color: Color(0xffADE8F4),
                                        child: GetEventPrice(
                                            eventID: docIDs[index]),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),

        ],
      ),
    );
  }
}
