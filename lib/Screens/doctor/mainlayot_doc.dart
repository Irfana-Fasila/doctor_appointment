import 'package:DocTime/Screens/appointments.dart';
import 'package:DocTime/Screens/doctor/doc_profile.dart';
import 'package:DocTime/Screens/doctor/homepg_doctor.dart';
import 'package:DocTime/Screens/patient/patent_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MainPageDoctor extends StatefulWidget {
  const MainPageDoctor({super.key});

  @override
  State<MainPageDoctor> createState() => _MainPageDoctorState();
}

class _MainPageDoctorState extends State<MainPageDoctor> {
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: const [
          Appointments(),
          ProfileHome(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: ((page) {
            setState(() {
              currentPage = page;
              _page.animateToPage(page,
                  duration: Duration(microseconds: 500),
                  curve: Curves.easeInOut);
            });
          }),
          items: const <BottomNavigationBarItem>[
            //   BottomNavigationBarItem(
            //       icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            //       label: "Home"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bookMedical),
                label: "Appointment"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userDoctor), label: "Profile"),
          ]),
    );
  }
}
