import 'package:DocTime/Screens/Admin/doctor_verification.dart';
import 'package:DocTime/Screens/Admin/homepage_admin.dart';
import 'package:DocTime/Screens/doctor/mainlayot_doc.dart';
import 'package:DocTime/Screens/home_page.dart';
import 'package:DocTime/components/button.dart';
import 'package:DocTime/main_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/globals.dart';

class DoctorOrPatient extends StatefulWidget {
  const DoctorOrPatient({Key? key}) : super(key: key);

  @override
  State<DoctorOrPatient> createState() => _DoctorOrPatientState();
}

class _DoctorOrPatientState extends State<DoctorOrPatient> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool _isLoading = true;

  void _setUser() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      var basicInfo = snap.data() as Map<String, dynamic>;
      isAdmin = basicInfo['type'] == 'admin' ? true : false;

      isvari = basicInfo['type'] == 'pending_doctor' ? true : false;

      isDoctor = basicInfo['type'] == 'doctor' ? true : false;
      // print(basicInfo['type'] == 'pending_doctor');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e);
    }
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  Future _move() async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('main', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return HomeAdmin();
    } else if (isvari) {
      return DoctorVerificationScreen();
    } else {
      return _isLoading
          ? Scaffold(
              body: Padding(
              padding: const EdgeInsets.all(12),
              child: SafeArea(
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                )),
              ),
            ))
          : isDoctor
              ? const MainPageDoctor()
              : const MainLayout();
    }
  }
}
