import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/user_preferences.dart';
import 'package:eraswithu/model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'home.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AddEvents> createState() => _AddEventsState(user);
}

class _AddEventsState extends State<AddEvents> {
  final User user;
  final _formKey = GlobalKey<FormState>();

  _AddEventsState(this.user);

  String? eventName,
      eventLocation,
      eventDate,
      eventDescription,
      eventImageURL,
      eventCreator,
      eventCity;
  double? eventPrice;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No File Selected'),
        ),
      );
      return;
    }
    setState(() {
      pickedFile = result.files.first;
    });
  }

  getCreatorName(creatorName) {
    eventCreator = creatorName;
  }

  getEventName(name) {
    eventName = name;
  }

  getEventLocation(location) {
    eventLocation = location;
  }

  getEventCity(location) {
    eventCity = location;
  }

  getEventDate(date) {
    eventDate = date;
  }

  getEventPrice(price) {
    eventPrice = double.parse(price);
  }

  getEventDescription(description) {
    eventDescription = description;
  }

  getEventImageURL(urlDownload) {
    eventImageURL = urlDownload;
  }

  int _selectedIndex = 0;

  //static const List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future createData() async {
    // final snackBar = SnackBar(
    //   content: const Text('Event Added'),
    //   action: SnackBarAction(
    //     label: 'Delete',
    //     onPressed: () {
    //       // Some code to undo the change.
    //     },
    //   ),
    // );

    // Section to upload Image and obtain URL

    final path = 'images/(${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    //print('Download Link: $urlDownload');
    eventImageURL = urlDownload;

    // End of Upload Image Section

    //print("Event Added");
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Event").doc(eventName);
    //Create Map

    final userProfile = user.profileData != null
        ? user.profileData!
        : UserPreferences.getUser();

    Map<String, dynamic> events = {
      "eventName": eventName,
      "eventLocation": eventLocation,
      "eventDate": eventDate,
      "eventPrice": eventPrice,
      "eventDescription": eventDescription,
      "eventURL": eventImageURL,
      "eventCreator": eventCreator = user.userID,
      "eventCity": eventCreator = userProfile.city,
    };
    await documentReference.set(events).whenComplete(() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        barrierDismissible: true,
        customAsset: 'assets/success.gif',
        text: 'Event Added Successfully',
        confirmBtnColor: Color(0xff0077B6),
        confirmBtnTextStyle: const TextStyle(
          //fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onConfirmBtnTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Home(user: user),
            ),
          );
        },
      );
      print("$eventName created");
    });

    //add hiddenUsers
    await documentReference.collection(Model.HIDDEN_USERS).add({});

    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Add an Event',
            style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff0077B6))),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Color(0xff0077B6)),
            tooltip: 'Cancel',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pickedFile == null)
                      GestureDetector(
                        onTap: selectFile,
                        child: Image.asset('assets/SelectImage.png'),
                      ),
                    if (pickedFile != null)
                      GestureDetector(
                        onTap: selectFile,
                        child: Image.file(
                          File(pickedFile!.path!),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name of the event',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is Missing';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String name) {
                    getEventName(name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Location is Missing';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String location) {
                    getEventLocation(location);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Date',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Date is Missing';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String date) {
                    getEventDate(date);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Price (€)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is Missing';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String price) {
                    getEventPrice(price);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Event Description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is Missing';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String description) {
                    getEventDescription(description);
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    backgroundColor: const Color(0xff0077B6),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (pickedFile == null) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        confirmBtnColor: Color(0xffFFC847),
                        title: 'Oops...',
                        text:
                            'Select an Image for your Event to have a better impact.',
                      );
                      // showDialog<String>(
                      //   context: context,
                      //   builder: (BuildContext context) => AlertDialog(
                      //     title: const Text('Image Missing'),
                      //     content: const Text(
                      //         'Select an Image for your Event to have a better impact.'),
                      //     actions: <Widget>[
                      //       TextButton(
                      //         onPressed: () => Navigator.pop(context, 'OK'),
                      //         child: const Text('OK'),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }
                    if (pickedFile != null) {
                      createData();
                    }
                  }
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(height: 10),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xffADE8F4),
                        color: const Color(0xff0077B6),
                      ),
                    ),
                  )
                ],
              ));
        } else {
          return const SizedBox(height: 50);
        }
      });
}
