import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/message_object.dart';
import 'package:eraswithu/data/user.dart';
import 'package:flutter/material.dart';
import 'package:eraswithu/data/storage_service.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import '../data/reactions_data.dart' as reactions_data;

//void main() => runApp(const Messaging());

class Messaging extends StatefulWidget {
  const Messaging(
      {super.key,
      required this.user,
      required this.doc,
      required this.subcollection});

  final User user;
  final String doc;
  final String subcollection;

  static const String _title = 'Messaging';

  @override
  MessagingState createState() => MessagingState();
}

class MessagingState extends State<Messaging> {
  final Storage storage = Storage();

  List<QueryDocumentSnapshot> listMessage = [];
  final ScrollController listScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Widget buildItem(int index, DocumentSnapshot? doc, userID) {
    if (doc != null) {
      MessageObject messageObject = MessageObject.fromDocument(doc);
      log(messageObject.toString());
      log("logged in user: " + widget.user.userID);
      if (messageObject.city != widget.user.profileData!.city) {
        return const SizedBox.shrink();
      }
      if (messageObject.name == widget.user.userID) {
        // Right (my message)
        return Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      userID == 'Guest' ? const SizedBox(width: 1) :
                      ReactionButtonToggle<String>(
                        onReactionChanged: (String? value, bool isChecked) {
                          debugPrint(
                              'Selected value: $value, isChecked: $isChecked');
                          storage.onSendReaction(
                              messageObject,
                              widget.user.userID,
                              value!,
                              widget.doc,
                              widget.subcollection);
                        },
                        reactions: reactions_data.reactions,
                        initialReaction: findLoggedInReaction(messageObject),
                        selectedReaction: reactions_data.reactions[0],
                      ),
                      //Icon(Icons.done, size: 20)
                    ],
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: const Color(0xff0077B6),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Stack(children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 10, right: 60, top: 5, bottom: 20),
                      //   child: Text(messageObject.name,
                      //       style: const TextStyle(
                      //           fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xff0077B6))),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 30, top: 10, bottom: 28),
                        child: Text(messageObject.text,
                            style: const TextStyle(
                                fontFamily: 'Karla', color: Colors.white)),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Row(
                          children: [
                            Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                        messageObject
                                            .sentTime.millisecondsSinceEpoch)
                                    .toString()
                                    .substring(10, 16),
                                style: const TextStyle(
                                    fontFamily: 'Karla',
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(
                              width: 5,
                            ),
                            //Icon(Icons.done, size: 20)
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 5,
                          left: 9,
                          child: Row(
                            children: <Widget>[
                              messageObject.reactions.contains('Happy') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Happy"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/happy.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Angry') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Angry"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/angry.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('In love') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "In love"
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/images/in-love.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Sad') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Sad"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/sad.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Surprised') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Surprised"
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/images/surprised.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Mad') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Mad"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/mad.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                            ],
                          )),
                    ]),
                  ),
                ],
              ),
            ));

        //   Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     Container(
        //       margin: EdgeInsets.only(left: 50, top: 5, bottom: 5, right: 10),
        //       child: Text(
        //           DateTime.fromMillisecondsSinceEpoch(
        //                   messageObject.sentTime.millisecondsSinceEpoch)
        //               .toString()
        //               .substring(10, 16),
        //           style: const TextStyle(
        //               fontFamily: 'Karla',
        //               color: Color(0xff0077B6),
        //               fontSize: 12,
        //               fontStyle: FontStyle.italic)),
        //     ),
        //     // Text
        //     Container(
        //       padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        //       width: 200,
        //       decoration: BoxDecoration(
        //           color: const Color(0xff0077B6), borderRadius: BorderRadius.circular(8)),
        //       margin: EdgeInsets.only(bottom: 10, right: 10),
        //       child: Text(
        //         messageObject.text,
        //         style:
        //             const TextStyle(fontFamily: 'Karla', color: Colors.white),
        //       ),
        //     )
        //   ],
        // );
      } else {
        return Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Row(
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: const Color(0xffADE8F4),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 40, top: 5, bottom: 20),
                        child: Text(messageObject.name,
                            style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.bold,
                                color: Color(0xff0077B6))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 100, top: 20, bottom: 30),
                        child: Text(messageObject.text,
                            style: const TextStyle(
                                fontFamily: 'Karla', color: Colors.black)),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Row(
                          children: [
                            Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                        messageObject
                                            .sentTime.millisecondsSinceEpoch)
                                    .toString()
                                    .substring(10, 16),
                                style: const TextStyle(
                                    fontFamily: 'Karla',
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(
                              width: 2,
                            ),
                            //Icon(Icons.done, size: 20)
                          ],
                        ),
                      ),
                      Positioned(
                          //Reaction of Other Users
                          bottom: 5,
                          left: 9,
                          child: Row(
                            children: <Widget>[
                              messageObject.reactions.contains('Happy') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Happy"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/happy.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Angry') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Angry"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/angry.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('In love') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "In love"
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/images/in-love.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Sad') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Sad"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/sad.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Surprised') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Surprised"
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/images/surprised.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                              messageObject.reactions.contains('Mad') &&
                                      findLoggedInReaction(messageObject)!
                                              .value !=
                                          "Mad"
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/mad.png'),
                                      width: 15,
                                      height: 15)
                                  : const SizedBox(width: 1),
                            ],
                          )),
                    ]),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 5,
                    child: Row(
                      children: [
                        userID == 'Guest' ? const SizedBox(width: 1) :

                        ReactionButtonToggle<String>(
                          onReactionChanged: (String? value, bool isChecked) {
                            debugPrint(
                                'Selected value: $value, isChecked: $isChecked');
                            storage.onSendReaction(
                                messageObject,
                                widget.user.userID,
                                value!,
                                widget.doc,
                                widget.subcollection);
                          },
                          reactions: reactions_data.reactions,
                          initialReaction: findLoggedInReaction(messageObject),
                          selectedReaction: reactions_data.reactions[0],
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        //Icon(Icons.done, size: 20)
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: storage.getChatStream(20, widget.doc, widget.subcollection),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            if (listMessage.length > 0) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) =>
                    buildItem(index, snapshot.data?.docs[index], widget.user.userID),
                itemCount: snapshot.data?.docs.length,
                reverse: false,
                controller: listScrollController,
              );
            } else {
              return const Center(child: Text("No message here yet..."));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black12,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInput(String userID) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff0077B6), width: 3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onSubmitted: (value) {
                    onSendMessage(textEditingController.text);
                  },
                  style: const TextStyle(
                      fontFamily: 'Karla', color: Colors.black, fontSize: 15),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: userID == 'Guest' ? 'Login to send message' : 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  focusNode: focusNode,
                  autofocus: false, // for the keyboard to appear automatically
                ),
              ),
            ),

            // Button send message
            Material(
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => userID == 'Guest' ? null : onSendMessage(textEditingController.text),
                  color: userID == 'Guest' ? Colors.grey : Color(0xff0077B6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onBackPress,
          child: Stack(
            children: <Widget>[

              Column(

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:20.0, right:20.0,top: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xffADE8F4),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Chat: ${widget.subcollection}',
                              style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  //fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0077B6)),
                        ),
                    ),
                  ),),
                  // List of messages
                  buildListMessage(),
                  // Sticker
                  const SizedBox.shrink(),
                  // Input content
                  buildInput(widget.user.userID),
                ],
              ),
              // Loading
              const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  void onSendMessage(String content) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      storage.sendMessage(
          MessageObject(
            name: widget.user.userID,
            sentTime: Timestamp.fromDate(DateTime.now()),
            city: widget.user.profileData!.city,
            text: content,
            reactions: "",
          ),
          widget.doc,
          widget.subcollection);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  Reaction<String>? findLoggedInReaction(MessageObject messageObject) {
    if (messageObject.reactions == "") {
      return reactions_data.defaultInitialReaction;
    } else {
      for (String reaction in messageObject.reactions.split(";")) {
        if (reaction.split(":")[0] == widget.user.userID) {
          for (Reaction reactionObject in reactions_data.reactions) {
            if (reactionObject.value == reaction.split(":")[1]) {
              return reactionObject as Reaction<String>;
            }
          }
        }
      }
      return reactions_data.defaultInitialReaction;
    }
  }
}
