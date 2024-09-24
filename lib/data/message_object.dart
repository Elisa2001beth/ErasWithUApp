import 'package:cloud_firestore/cloud_firestore.dart';

class MessageObject{
  String name;
  Timestamp sentTime;
  String city;
  String text;
  String reactions;

  MessageObject({
    required this.name, required this.sentTime, required this.city, required this.text, required this.reactions});

  Map<String, dynamic> toJson() => {
    'name': name,
    'sentTime': sentTime,
    'city': city,
    'text': text,
    'reactions': reactions,
  };

  factory MessageObject.fromDocument(DocumentSnapshot document) {
    return MessageObject(
      name: document['name'],
      sentTime: document['sentTime'].runtimeType == Timestamp ? document['sentTime'] : Timestamp.fromDate(document['sentTime'].toDate()),
      city: document['city'],
      text: document['text'],
      reactions: document['reactions'],
    );
  }

  String toString() {
    return 'MessageObject{name: $name, sentTime: $sentTime, city: $city, text: $text, reactions: $reactions}';
  }
}