import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetEventData extends StatelessWidget {
  final String eventID;

  GetEventData({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['eventName']}',
              style: const TextStyle(fontWeight: FontWeight.bold));
          //return Text('${data['eventName']}', style: TextStyle(fontWeight: FontWeight.bold),);
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetEventData2 extends StatelessWidget {
  final String eventID;

  GetEventData2({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['eventLocation']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetEventData3 extends StatelessWidget {
  final String eventID;

  GetEventData3({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['eventDate']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetEventPrice extends StatelessWidget {
  final String eventID;

  GetEventPrice({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('Entry: ${data['eventPrice']} €');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}

class GetImageData extends StatelessWidget {
  final String eventID;

  GetImageData({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return CachedNetworkImage(imageUrl: data['eventURL'],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(value: downloadProgress.progress),
                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
            Image.network(
            data['eventURL'],
            // loadingBuilder: (BuildContext context, Widget child,
            //     ImageChunkEvent? loadingProgress) {
            //   if (loadingProgress == null) {
            //     return child;
            //   }
            //   return Center(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: CircularProgressIndicator(
            //         value: loadingProgress.expectedTotalBytes != null
            //             ? loadingProgress.cumulativeBytesLoaded /
            //                 loadingProgress.expectedTotalBytes!
            //             : null,
            //       ),
            //     ),
            //   );
            // },
          );
        }
        return const Text('Loading Image....');
      }),
    );
  }
}

//new for know the event creator
class GetEventCreator extends StatelessWidget {
  final String eventID;

  GetEventCreator({required this.eventID});

  @override
  Widget build(BuildContext context) {
    // Get the Collection from Firebase
    CollectionReference events = FirebaseFirestore.instance.collection('Event');

    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(eventID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['eventCreator']}');
        }
        return const Text('Loading Data....');
      }),
    );
  }
}
