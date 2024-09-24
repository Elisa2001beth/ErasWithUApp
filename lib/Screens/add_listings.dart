import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraswithu/data/user.dart';
import 'package:eraswithu/data/user_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'home.dart';

class AddListings extends StatefulWidget {
  const AddListings({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AddListings> createState() => _AddListingsState(user);
}

class _AddListingsState extends State<AddListings> {
  final User user;
  final _formKey = GlobalKey<FormState>();

  _AddListingsState(this.user);

  String? listingName,
      listingLocation,
      listingDescription,
      listingImageURL,
      listingSeller,
      listingCity;
  double? listingPrice;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
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

  getListingSeller(sellerName) {
    listingSeller = sellerName;
  }

  getListingCity(sellerName) {
    listingCity = sellerName;
  }

  getlistingName(name) {
    listingName = name;
  }

  getlistingLocation(location) {
    listingLocation = location;
  }

  getlistingPrice(price) {
    listingPrice = double.parse(price);
  }

  getlistingDescription(description) {
    listingDescription = description;
  }

  getlistingImageURL(urlDownload) {
    listingImageURL = urlDownload;
  }

  Future createData() async {
    // final snackBar = SnackBar(
    //   content: const Text('Listing Added'),
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

    final snapshot = await uploadTask!.whenComplete(() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        barrierDismissible: true,
        customAsset: 'assets/success.gif',
        text: 'Listing Added Successfully',
        confirmBtnColor: Color(0xff0077B6),
        confirmBtnTextStyle: const TextStyle(
          //fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    });

    final urlDownload = await snapshot.ref.getDownloadURL();
    //print('Download Link: $urlDownload');
    listingImageURL = urlDownload;

    // End of Upload Image Section

    //print("listing Added");
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Listing").doc();
    //Create Map

    final userProfile = user.profileData != null
        ? user.profileData!
        : UserPreferences.getUser();

    Map<String, dynamic> listings = {
      "listingName": listingName,
      "listingLocation": listingLocation,
      "listingPrice": listingPrice,
      "listingDescription": listingDescription,
      "listingImageURL": listingImageURL,
      "listingSeller": listingSeller = userProfile.name,
      "listingCity": listingCity = userProfile.city,
    };
    documentReference.set(listings).whenComplete(() {
      print("$listingName created");
    });
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Add a Listing',
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
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name of the Listing',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'What is the name of your item?';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String name) {
                    getlistingName(name);
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
                    labelText: 'PickUp Location',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Where should the buyer come ?';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String location) {
                    getlistingLocation(location);
                  },
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Date',
                  ),
                  onChanged: (String date) {
                    getlistingDate(date);
                  },
                ),
              ),
              */
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Item Price',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Are you giving away for free ? Then Enter 0.';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String price) {
                    getlistingPrice(price);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  // Normal textInputField will be displayed
                  maxLines: 5,
                  // When user presses enter it will adapt to it
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xff0077B6), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Item Description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'At least write something about your item.';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (String description) {
                    getlistingDescription(description);
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                child: ElevatedButton(
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
                              'Select an Image for your Listing to help the buyers decide better.',
                        );
                        // showDialog<String>(
                        //   context: context,
                        //   builder: (BuildContext context) => AlertDialog(
                        //     title: const Text('Image Missing'),
                        //     content: const Text(
                        //         'Select an Image for your Listing to help the buyers decide better.'),
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
                    // if (pickedFile == null) {
                    //   showDialog<String>(
                    //     context: context,
                    //     builder: (BuildContext context) => AlertDialog(
                    //       title: const Text('Image Missing'),
                    //       content: const Text('Select an Image for your Listing to help the buyers decide better.'),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           onPressed: () => Navigator.pop(context, 'OK'),
                    //           child: const Text('OK'),
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    //   // ScaffoldMessenger.of(context).showSnackBar(
                    //   //   const SnackBar(
                    //   //     content: Text('Please Select an Image'),
                    //   //   ),
                    //   // );
                    // }
                    // if (pickedFile! == null) {
                    //   createData();
                    // }
                  },
                  child: const Text('Confirm'),
                ),
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
