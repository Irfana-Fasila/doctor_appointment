import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';

import '../components/button.dart';

class BookingScreen extends StatefulWidget {
  final String doctor;
  final String doctorUid;

  const BookingScreen({Key? key, required this.doctor, required this.doctorUid})
      : super(key: key);
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  late String dateUTC;
  late String dateTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  // function for selecting appointment date
  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    ).then(
      (date) {
        setState(
          () {
            selectedDate = date!;
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }

  // function for selecting appointment time
  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    setState(() {
      timeText = formattedTime;
      _timeController.text = timeText;
    });
    dateTime = selectedTime.toString().substring(10, 15);
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    selectTime(context);
    _doctorController.text = widget.doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appointment booking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              const Image(
                image: AssetImage('assets/Images/appointment.png'),
                height: 250,
              ),
              const SizedBox(
                height: 10,
              ),

              // form
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      // enter patient details
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          'Enter Patient Details',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // patient Name
                      TextFormField(
                        controller: _nameController,
                        focusNode: f1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Patient Name';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          fillColor: Colors.grey[350],
                          hintText: 'Patient Name*',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // patient phone number
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        focusNode: f2,
                        controller: _phoneController,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          hintText: 'Mobile*',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Phone number';
                          } else if (value.length < 10) {
                            return 'Please Enter correct Phone number';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          f2.unfocus();
                          FocusScope.of(context).requestFocus(f3);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // disease description
                      TextFormField(
                        focusNode: f3,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f3.unfocus();
                          FocusScope.of(context).requestFocus(f4);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Doctor name
                      TextFormField(
                        readOnly: true,
                        controller: _doctorController,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter Doctor name';
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          hintText: 'Doctor Name*',
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // appointment date
                      TextFormField(
                        onTap: () {
                          selectDate(context);
                        },
                        focusNode: f4,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.date_range_outlined,
                            color: Colors.greenAccent[700],
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          hintText: 'Select Date*',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        controller: _dateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter the Date';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          f4.unfocus();
                          FocusScope.of(context).requestFocus(f5);
                        },
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // appointment time
                      TextFormField(
                        onTap: () {
                          selectTime(context);
                        },
                        focusNode: f5,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.timer_outlined,
                            color: Colors.greenAccent[700],
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          hintText: 'Select Time*',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        controller: _timeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter the Time';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          f5.unfocus();
                        },
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      Button(
                        width: double.infinity,
                        title: 'Make Apponment',
                        disable: false,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _createAppointment();
                            Navigator.of(context).pushNamed('success_boking');
                          }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    // print(dateUTC + ' ' + date_Time + ':00');
    String appointId = '${user.uid}${widget.doctorUid}$dateUTC $dateTime}';
    // print('${widget.doctorUid}.');
    // print('${user.uid}.');
    // print('${appointId}.');

    var details = {
      'patientName': _nameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'doctorName': _doctorController.text,
      'date': DateTime.parse('$dateUTC $dateTime:00'),
      'patientId': user.uid,
      'doctorId': widget.doctorUid,
      //help in cancelling appointment
      'appointmentID': appointId,
    };

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('pending')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('all')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    // add to doctor data
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.doctorUid)
        .collection('pending')
        .doc(appointId)
        .set(details, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.doctorUid)
        .collection('all')
        .doc(appointId)
        .set(details, SetOptions(merge: true));
  }
}
