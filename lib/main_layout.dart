import 'package:DocTime/Screens/appointments.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:DocTime/Screens/home_page.dart';
import 'package:DocTime/Screens/patient/doctor_list.dart';

import 'Screens/patient/patent_profile.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
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
          HomePage(),
          DoctorList(),
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
                  duration: const Duration(microseconds: 500),
                  curve: Curves.easeInOut);
            });
          }),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
                label: "Home"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
                label: "Appoinment"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user), label: "Profile"),
          ]),
    );
  }
}
