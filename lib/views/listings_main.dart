import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/presenters/presenter_listing_page.dart';
import 'package:eraswithu/views/listings_details.dart';
import 'package:flutter/material.dart';
import '../Screens/login_screen.dart';
import '../Screens/add_listings.dart';
import '../data/user_preferences.dart';


class MyListings extends StatefulWidget {
  const MyListings({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyListings> createState() => _MyListingsState(user);
}

class _MyListingsState extends State<MyListings> {
  final User user;

  _MyListingsState(this.user);

  int index = 0;
  int _selectedIndex = 0;

  // document IDs
  List<String> docIDs = [];

  // get DocIDs




  //supongo que esto es para acceder a la base de datos de eventos que
  //habra que cambiar a listings porque si no cogera todo lo que haya en events

  Future getDocID() async {
    final userProfile = user.profileData != null
        ? user.profileData!
        : UserPreferences.getUser();


    setState(() => docIDs.clear());
    await FirebaseFirestore.instance.collection('Listing').where("listingCity", isEqualTo: userProfile.city).get().then(
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
                    'You need to Login in order to  add new Listings.',
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
                    onPressed: () => Navigator.pop(context, 'Cancel', ),
                    child: const Text('Cancel', style: TextStyle(
                        color: Color(0xff0077B6))),
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
              MaterialPageRoute(builder: (context) => AddListings(user: user)),
            );
          }
        },
        backgroundColor: const Color(0xff0077B6),
        //label: const Text('Add an Event'),

        child: const Icon(Icons.add),
      ),
      extendBodyBehindAppBar: false,

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
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: const Color(0xff0077B6)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListingDetails(
                                    ListingID: docIDs[index],
                                    user: user,
                                  )),
                        );
                      },
                      child: Container(
                        height: 100,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GetImageData(listingID: docIDs[index]),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //     width: 150.0,
                            //     height: 100.0,
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(10),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(12.0),
                            //         child: GetImageData(listingID: docIDs[index]),
                            //       ),
                            //     )),
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GetListingData(listingID: docIDs[index]),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: GetListingPrice(listingID: docIDs[index]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: GetListingData2(listingID: docIDs[index]),
                                    ),
                                  ],
                                )),
                          ],
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
