import 'package:DocTime/Screens/appointments.dart';
import 'package:DocTime/Screens/personal_info.dart';
import 'package:DocTime/firestore_data/notification_list.dart';
import 'package:DocTime/utils/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../firestore_data/appoinment_history.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';

  Future<void> _getUser() async {
    user = _auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(isDoctor ? 'doctor' : 'patient')
        .doc(user.uid)
        .get();
    setState(() {
      var snapshot = snap.data() as Map<String, dynamic>;

      image = snapshot['profilePhoto'] ?? image;
    });
    print(snap.data());
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              // color: Colors.greenAccent,
              height: 250,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () {
                          _showSelectionDialog(context);
                        },
                        child: Container(
                          // width: 100,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(image),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    user.displayName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25.38),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserDetails()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    Text(
                      "Personal informaion",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Appointments()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.approval,
                      color: Colors.grey,
                    ),
                    Text(
                      "Appoinments",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const NotificationList()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.notifications,
                      color: Colors.grey,
                    ),
                    Text(
                      "Notification",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AppointmentHistoryList()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    Text(
                      "History",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 12);

    if (file != null) {
      var im = await file.readAsBytes();
      // upload image to cloud
      await uploadFile(im, file.name);
      return;
    }

    // print('No photo was selected or taken');
  }

  Future _showSelectionDialog(BuildContext conntext) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('From gallery'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text('Take a photo'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

//upload file
  Future uploadFile(Uint8List img, String fileName) async {
    final destination = 'dp/${user.displayName}-$fileName';
    try {
      final ref = storage.ref(destination);

      UploadTask uploadTask = ref.putData(img);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('image url : $downloadUrl');

      setState(() {
        image = Uri.decodeFull(downloadUrl.toString());
      });
      FirebaseFirestore.instance
          .collection(isDoctor ? 'doctor' : 'patient')
          .doc(user.uid)
          .set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));

      // main user data
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profilePhoto': downloadUrl,
      }, SetOptions(merge: true));

      // print("uploaded !!!");
    } catch (e) {
      // print(e.toString());
      // print('error occured');
    }
  }

  //Logot dialog
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cnslButton = TextButton(
        child: const Text(
          "Cancel",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pop(context);
        });
    Widget okButton = TextButton(
        child: const Text(
          "OK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          _signOut();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.logout),
          Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: const Text(
        "Are you sure ?",
      ),
      actions: [
        cnslButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
