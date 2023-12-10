import 'package:DocTime/Screens/Admin/doctor_verification.dart';
import 'package:DocTime/Screens/Admin/homepage_admin.dart';
import 'package:DocTime/Screens/doctor/mainlayot_doc.dart';
import 'package:DocTime/Screens/doctor_or_patient.dart';
import 'package:DocTime/Screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DocTime/Screens/auth_page.dart';
import 'package:DocTime/Screens/booking_page.dart';
import 'package:DocTime/Screens/doctor_details.dart';
import 'package:DocTime/Screens/doctor_register.dart';
import 'package:DocTime/Screens/success_booked.dart';
import 'package:DocTime/firebase_options.dart';
import 'package:DocTime/main_layout.dart';
import 'package:DocTime/utils/config.dart';

import 'utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for all platforms(android, ios, web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();

    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.greenAccent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.greenAccent)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          floatingLabelStyle: TextStyle(color: Colors.greenAccent),
          prefixIconColor: Colors.black38,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.greenAccent,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            user == null ? const AuthPage() : const DoctorOrPatient(),
        'main': (context) => isAdmin
            ? const HomeAdmin()
            : isvari
                ? const DoctorVerificationScreen()
                : isDoctor
                    ? const MainPageDoctor()
                    : const MainLayout(),
        'doc_details': (context) => DoctorDetails(),
        'booking_page': (context) => const BookingPage(),
        'success_boking': (context) => const AppoinmentBooked(),
        'doctorsignup': (context) => const DoctorSignUp(),
      },
    );
  }
}
