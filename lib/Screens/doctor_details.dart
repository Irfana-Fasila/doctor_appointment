import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:DocTime/components/button.dart';
import 'package:DocTime/components/custom_apbar.dart';
import 'package:DocTime/utils/config.dart';

class DoctorDetails extends StatefulWidget {
  String? doctor = "P";
  DoctorDetails({Key? key, this.doctor}) : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //creating custom widget
      appBar: CustomAppBar(
        appTitle: "Doctor Details",
        icone: const FaIcon(Icons.arrow_back_ios),
        actions: [
          //flav button
          IconButton(
              onPressed: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              icon: FaIcon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              )),
        ],
      ),
      body: SafeArea(
          child: StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('doctor')
                  .orderBy('name')
                  .startAt([widget.doctor]).endAt(
                      ['${widget.doctor!}\uf8ff']).snapshots(),
              builder: (context, snapshot) {
                return Column(
                  children: <Widget>[
                    AboutDoctor(),
                    DetailBody(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Button(
                        width: double.infinity,
                        title: 'Book Appoinment',
                        disable: false,
                        onPressed: () {
                          Navigator.of(context).pushNamed('booking_page');
                        },
                      ),
                    )
                  ],
                );
              })),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage("assets/Images/doctor_1.jfif"),
            backgroundColor: Colors.white,
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            "Dr shameel",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              "MBBS (Internatinal college India),MRCP (ROYAL COLLEGE OF PYSICHS UNITED Arabia)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Al Mas Hospital',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          SizedBox(height: 18),
          DoctorInfo(),
          SizedBox(
            height: 25,
          ),
          Text(
            "Abou Doctor",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          SizedBox(
            height: 18,
          ),
          Text(
            "Dr,Shameel is a experinced dentit at kerala He is graduated since 2016,and completed his training at mims hospital",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Row(
      children: const <Widget>[
        InfoCard(label: "patient", value: '100'),
        SizedBox(width: 15),
        InfoCard(label: "Experince", value: "10 Year"),
        SizedBox(width: 15),
        InfoCard(label: "Rating", value: '4.6')
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.greenAccent,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 15,
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ));
  }
}
