import 'package:DocTime/Screens/Admin/doctors_list.dart';
import 'package:DocTime/Screens/Admin/verification_doctor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
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
          DoctorVerification(),
          DoctorsList(),
          // ProfileHome(),
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
                label: "Verification"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userDoctor), label: "Doctors"),
          ]),
    );
  }
}
