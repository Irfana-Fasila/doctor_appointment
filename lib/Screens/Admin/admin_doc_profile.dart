import 'dart:math';

import 'package:DocTime/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DocProfileAdmin extends StatefulWidget {
  String? doctorid;
  DocProfileAdmin({
    Key? key,
    this.doctorid,
  }) : super(key: key);
  @override
  State<DocProfileAdmin> createState() => _DocProfileAdminState();
}

class _DocProfileAdminState extends State<DocProfileAdmin> {
  String image =
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  // map of all the details
  Map<String, dynamic> details = {};

  Future<void> _getUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(widget.doctorid)
        .get();

    setState(() {
      details = snap.data() as Map<String, dynamic>;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.doctorid);
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  details["name"] ?? "Profile",
                  style: const TextStyle(
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
                    if (key == "id") {
                      return Container();
                    } else {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: InkWell(
                          splashColor: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
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
                    title: "Back",
                    disable: false,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(
                  width: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
