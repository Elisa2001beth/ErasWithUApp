import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/Screens/hideseek_screen.dart';
import 'package:eraswithu/Screens/profile_screen.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/model.dart';
import 'package:flutter/material.dart';

import 'messaging_screen.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.eventID, required this.user});
  final String eventID;
  final User user;

  @override
  State<EventDetails> createState() => _EventDetailsState(eventID, user);
}

class _EventDetailsState extends State<EventDetails> {
  final String eventID;
  final User user;

  _EventDetailsState(this.eventID, this.user);

  Map<String, dynamic> data = {};

  final Model model = Model();
  String creatorImgPath = '';
  late User userCreator;
  List<String> imgsPath = [];

  @override
  void initState() {
    super.initState();Future.delayed(Duration.zero,() async {
      //your async 'await' codes goes here
      imgsPath = await model.getImgsInEvent(eventID);
      print("ImgsPath: $imgsPath");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference events = FirebaseFirestore.instance.collection('Event');
    // final userProfile = user.profileData != null
    //     ? user.profileData!
    //     : UserPreferences.getUser();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Event Details',
            style: TextStyle(
                fontFamily: 'Rubik',
                //fontSize: 18,
                //fontWeight: FontWeight.bold,
                color: Color(0xff0077B6))),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: events.doc(eventID).get(),
          builder: ((context, snapshot) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;

            Future.delayed(Duration.zero, () async {
              //your async 'await' codes goes here
              userCreator = await model.getUser(data['eventCreator']);
              creatorImgPath = userCreator.profileData!.imagePath;
              setState(() {});
            });

            return Container(
              //width: double.infinity,
              //height: double.infinity,
              margin:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff0077B6), width: 3),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CreatorWidget(
                        imagePath: creatorImgPath,
                        onClicked: onCreatorImgButton,
                      ),
                      Container(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('CREATED BY',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text('${data['eventCreator']}',
                              style: const TextStyle(
                                  fontFamily: 'Karla',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0077B6))),
                          const Divider(),
                        ],
                      ),
                    ],
                  ),

                  /*CreatorWidget(
                    imagePath: userProfile.imagePath,
                    onClicked: () {},
                  ),
                  Row(//for creator of the event
                      children: <Widget>[
                    Text('CREATED BY',
                        style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ]),
                  Text('${data['eventCreator']}',
                      style: const TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0077B6))), */
                  const Divider(),
                  Text('${data['eventName']}',
                      style: const TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0077B6))),
                  const Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        //height:175,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: data['eventURL'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Divider(),
                          Text('Location:    ',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Divider(),
                          Text('Date: ',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Divider(),
                          Text('Price: ',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text('${data['eventLocation']}',
                                style: const TextStyle(
                                    fontFamily: 'Karla', fontSize: 16)),
                            const Divider(),
                            Text('${data['eventDate']}',
                                style: const TextStyle(
                                    fontFamily: 'Karla', fontSize: 16)),
                            const Divider(),
                            Text('${data['eventPrice']} €',
                                style: const TextStyle(
                                    fontFamily: 'Karla', fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text('\n${data['eventDescription']}',
                            style: const TextStyle(
                                fontFamily: 'Karla', fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                              backgroundColor: const Color(0xff0077B6),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Messaging(
                                        user: user,
                                        doc: "event",
                                        subcollection: eventID,
                                      )),
                            );
                          },
                          child: const Text('Event Chat',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: const Color(0xff0077B6),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            )),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Oops ! Tickets Sold Out!',
                                  style: TextStyle(
                                      fontFamily: 'Karla', fontSize: 16)),
                            ),
                          );
                        },
                        child: const Text('Buy Tickets',
                            style: TextStyle(
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  const Text('Wanna play a game at this event:'),
                  const SizedBox(height: 10.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 55),
                        backgroundColor: const Color(0xffADE8F4),
                        //padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HideAndSeek(
                                  user: user,
                                  eventID: eventID,
                                )),
                      );
                    },
                    icon: const Icon(Icons.gamepad,
                        color:
                            Color(0xff0077B6)), //icon data for elevated button
                    label: const Text("Hide & Seek",
                        style: TextStyle(
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0077B6),
                            fontSize: 16)),
                    // const Text('Hide & Seek',
                    //     style: TextStyle(
                    //         fontFamily: 'Karla',
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16)),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void onCreatorImgButton() {
    if (!ProfilePage.notGuest(user.userID, context)) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  user: user,
                  userToShow: userCreator,
                )));
  }
}

class CreatorWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const CreatorWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Row(//for creator of the event
            children: <Widget>[
          buildImage(),
          /*Text('CREATED BY',
              style: const TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),*/
        ]),
      ]),
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
          width: 50,
          height: 50,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }
}
