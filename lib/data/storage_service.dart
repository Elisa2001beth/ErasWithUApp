import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/message_object.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);

    try{
      await storage.ref('images/$fileName').putFile(file);

    }on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async{
    String downloadURL = await storage.ref('images/$imageName').getDownloadURL();
    return downloadURL;
  }


  Stream<QuerySnapshot> getChatStream(int limit, String docName, String subcollectionName) {
    return firebaseFirestore
        .collection("messages")
        .doc(docName)
        .collection(subcollectionName)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(MessageObject messageObject, String docName, String subcollectionName) {
    DocumentReference documentReference = firebaseFirestore
        .collection("messages")
        .doc(docName)
        .collection(subcollectionName)
        .doc(messageObject.sentTime.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageObject.toJson(),
      );
    });
  }

  void onSendReaction(MessageObject messageObject, String username, String reactionType, String docName, String subcollectionName) {

    if(!messageObject.reactions.contains(username)) messageObject.reactions += username + ":" + reactionType + ";";
    else{
      String newReaction = "";
      List<String> reactions = messageObject.reactions.split(";");
      for(String reaction in reactions){
        if(reaction.split(":")[0] == username) newReaction += username + ":" + reactionType + ";";
        else newReaction += reaction + ";";
      }
      messageObject.reactions = newReaction;
    }

    DocumentReference documentReference = firebaseFirestore
        .collection("messages")
        .doc(docName)
        .collection(subcollectionName)
        .doc(messageObject.sentTime.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
        documentReference,
        messageObject.toJson(),
      );
    });


  }
}