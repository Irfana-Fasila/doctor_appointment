import 'dart:math';

import 'package:DocTime/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/updateprofile.dart';
import '../utils/globals.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  // map of all the details
  Map<String, dynamic> details = {};

  Future<void> _getUser() async {
    user = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(isDoctor ? 'doctor' : 'patient')
        .doc(user.uid)
        .get();

    setState(() {
      details = snap.data() as Map<String, dynamic>;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Your Profile ",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 100,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(details["profilePhoto"] ?? image),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      String key = details.keys.elementAt(index);
                      String value = details[key] == null
                          ? 'Not Added'
                          : details[key].toString();

                      String label = key[0].toUpperCase() + key.substring(1);
                      if (key == "id" ||
                          key == "profilePhoto" ||
                          key == "type" ||
                          key == "email" ||
                          key == "rating" ||
                          key == "RegisterId" ||
                          key == "email") {
                        return Container();
                      } else {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUserDetails(
                                    label: label,
                                    field: key,
                                    value: value,
                                  ),
                                ),
                              ).then((value) {
                                // reload page
                                _getUser();
                                setState(() {});
                              });
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                height: MediaQuery.of(context).size.height / 14,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      value.substring(0, min(20, value.length)),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  // Spacer(),
                  Button(
                      width: double.infinity,
                      title: "Save",
                      disable: false,
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
