import 'package:DocTime/components/appoinment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../utils/globals.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({Key? key}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  // delete appointment from both patient and doctor
  Future<void> deleteAppointment(
      String docID, String doctorId, String patientId) async {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(doctorId)
        .collection('pending')
        .doc(docID)
        .delete();
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(patientId)
        .collection('pending')
        .doc(docID)
        .delete();
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  String _timeFormatter(String timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(timestamp));
    return formattedTime;
  }

  // alert box for confirmation of deleting appointment
  showAlertDialog(BuildContext context, String doctorId, String patientId) {
    // No
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // YES
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        deleteAppointment(_documentID, doctorId, patientId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Delete"),
      content: const Text("Are you sure you want to delete this Appointment?"),
      actions: [
        cancelButton,
        continueButton,
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

  // helping in removing pending appointment
  _checkDiff(DateTime date) {
    var diff = DateTime.now().difference(date).inHours;

    if (diff > 23) {
      return true;
    } else {
      return false;
    }
  }

  // for comparing date
  _compareDate(String date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .doc(user.uid)
            .collection('pending')
            .orderBy('date')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.greenAccent,
              ),
            );
          }
          return snapshot.data!.size == 0
              ? Container(
                  child: Center(
                    child: Text(
                      'No Appointment Scheduled',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    print(_compareDate(document['date'].toDate().toString()));
                    // delete past appointments from pending appointment list
                    if (_checkDiff(document['date'].toDate())) {
                      deleteAppointment(document.id, document['doctorId'],
                          document['patientId']);
                    }

                    // each appointment
                    if (_compareDate(document['date'].toDate().toString())) {
                      return Card(
                        color: Colors.greenAccent,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      isDoctor
                                          ? document['patientName']
                                          : document['doctorName'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    isDoctor
                                        ? ''
                                        : "Patient name: ${document['patientName']}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Time: ${_timeFormatter(document['date'].toDate().toString())}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Description : ${document['description']}',
                                    style: const TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red),
                                      ),
                                      onPressed: () {
                                        _documentID = document.id;
                                        showAlertDialog(
                                            context,
                                            document['doctorId'],
                                            document['patientId']);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        elevation: 2,
                        child: SizedBox(
                          height: 80,
                          child: Center(
                            child: Text(
                              'No Appointment Scheduled Today',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
        },
      ),
    );
  }
}
