import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/Screens/profile_screen.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/model.dart';
import 'package:flutter/material.dart';

import 'messaging_screen.dart';

class ListingDetails extends StatefulWidget {
  const ListingDetails(
      {super.key, required this.ListingID, required this.user});
  final String ListingID;
  final User user;

  @override
  State<ListingDetails> createState() => _ListingDetailsState(ListingID, user);
}

class _ListingDetailsState extends State<ListingDetails> {
  final String ListingID;
  final User user;

  _ListingDetailsState(this.ListingID, this.user);

  //int _selectedIndex = 0;
  Map<String, dynamic> data = {};

  final Model model = Model();
  String sellerImgPath = '';
  late User userSeller;

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');
    /*final userProfile = user.profileData != null
        ? user.profileData!
        : UserPreferences.getUser();*/

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Listing Details',
            style: TextStyle(
                fontFamily: 'Rubik',
                //fontSize: 18,
                //fontWeight: FontWeight.bold,
                color: Color(0xff0077B6))),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: events.doc(ListingID).get(),
          builder: ((context, snapshot) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            Future.delayed(Duration.zero, () async {
              //your async 'await' codes goes here
              userSeller = await model.getUser(data['listingSeller']);

              sellerImgPath = userSeller.profileData!.imagePath;
              setState(() {});
            });

            return Container(
              //width: double.infinity,
              //height: double.infinity,
              margin: const EdgeInsets.all(10.0),
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
                      SellerWidget(
                        imagePath: sellerImgPath,
                        onClicked: onSellerImgButton,
                      ),
                      Container(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('SELLER',
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text('${data['listingSeller']}',
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
                  const Divider(),
                  Text('${data['listingName']}',
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
                            imageUrl: data['listingImageURL'],
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: <Widget>[
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(10),
                  //       child: Image.network(
                  //         '${data['listingImageURL']}',
                  //         height: 175,
                  //         //width: 150,
                  //         fit: BoxFit.fitWidth,
                  //         //width: 300,
                  //         loadingBuilder: (BuildContext context, Widget child,
                  //             ImageChunkEvent? loadingProgress) {
                  //           if (loadingProgress == null) {
                  //             return child;
                  //           }
                  //           return Center(
                  //             child: CircularProgressIndicator(
                  //               value: loadingProgress.expectedTotalBytes !=
                  //                       null
                  //                   ? loadingProgress.cumulativeBytesLoaded /
                  //                       loadingProgress.expectedTotalBytes!
                  //                   : null,
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                            Text('${data['listingLocation']}',
                                style: const TextStyle(
                                    fontFamily: 'Karla', fontSize: 16)),
                            const Divider(),
                            Text('${data['listingPrice']} €',
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
                        child: Text('\n${data['listingDescription']}',
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0077B6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      doc: "listing",
                                      subcollection: ListingID,
                                    )),
                          );
                        },
                        //esto tambien tiene que ir fuera
                        child: const Text('Start Chat',
                            style: TextStyle(
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    ));
  }

  void onSellerImgButton() {
    if (!ProfilePage.notGuest(user.userID, context)) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                  user: user,
                  userToShow: userSeller,
                )));
  }
}

class SellerWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const SellerWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
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
