import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetListingData extends StatelessWidget {
  final String listingID;

  GetListingData({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Text('${data['listingName']}',
                style: const TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          );
          //return Text('${data['eventName']}', style: TextStyle(fontWeight: FontWeight.bold),);
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetListingData2 extends StatelessWidget {
  final String listingID;

  GetListingData2({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['listingLocation']}',
              style: const TextStyle(
                fontFamily: 'Karla',
                fontSize: 18,
                //fontWeight: FontWeight.bold,
              ));
          //return Text('${data['eventName']}', style: TextStyle(fontWeight: FontWeight.bold),);
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetListingData3 extends StatelessWidget {
  final String listingID;

  GetListingData3({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['listingDescription']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetListingCity extends StatelessWidget {
  final String listingID;

  GetListingCity({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
    FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['listingCity']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetListingPrice extends StatelessWidget {
  final String listingID;

  GetListingPrice({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['listingPrice']} €',
              style: const TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                  color: Color(0xff0077B6)));
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetImageData extends StatelessWidget {
  final String listingID;

  GetImageData({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return CachedNetworkImage(
            imageUrl: data['listingImageURL'],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  )),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
          // CachedNetworkImage(imageUrl: data['listingImageURL'],
          //         progressIndicatorBuilder: (context, url, downloadProgress) =>
          //           ()if (downloadProgress == null) {
          //             return child;
          //           }
          //           return Center(
          //             child: CircularProgressIndicator(
          //               value: loadingProgress.expectedTotalBytes != null
          //                   ? loadingProgress.cumulativeBytesLoaded /
          //                       loadingProgress.expectedTotalBytes!
          //                   : null,
          //             ),
          //           );
          //         },
          //       );

          //   CachedNetworkImage(
          //   imageUrl: data['listingImageURL'],
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: CircularProgressIndicator(value: downloadProgress.progress),
          //       ),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // );

          // loadingBuilder: (BuildContext context, Widget child,
          //     ImageChunkEvent? loadingProgress) {
          //   if (loadingProgress == null) {
          //     return child;
          //   }
          //   return Center(
          //     child: CircularProgressIndicator(
          //       value: loadingProgress.expectedTotalBytes != null
          //           ? loadingProgress.cumulativeBytesLoaded /
          //               loadingProgress.expectedTotalBytes!
          //           : null,
          //     ),
          //   );
          // },

        }
        return const Text('Loading Image....');
      }),
    );
  }
}

//new for know the listing seller
class GetListingSeller extends StatelessWidget {
  final String listingID;

  GetListingSeller({required this.listingID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events =
        FirebaseFirestore.instance.collection('Listing');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(listingID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['listingSeller']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}
