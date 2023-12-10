import 'package:DocTime/Screens/booking_page.dart';
import 'package:DocTime/Screens/booking_screen.dart';
import 'package:DocTime/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

class DoctorProfile extends StatefulWidget {
  String? doctor = "P";

  DoctorProfile({Key? key, this.doctor}) : super(key: key);
  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  // // for making phone call
  _launchCaller(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctor')
                .orderBy('name')
                .startAt([widget.doctor]).endAt(
                    ['${widget.doctor!}\uf8ff']).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                );
              }
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 5),
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_left_sharp,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          // doctor profile pic
                          CircleAvatar(
                            backgroundImage: NetworkImage(document[
                                    'profilePhoto'] ??
                                'https://www.iconpacks.net/icons/1/free-doctor-icon-284-thumb.png'),
                            backgroundColor: Colors.white,
                            radius: 65.0,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // doctor name
                          Text(
                            document['name'] ?? '-',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // doctor specialization
                          Text(
                            document['specialization'] ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // rating
                          Rating(
                              rating:
                                  double.parse(document['rating'].toString())),
                          const SizedBox(
                            height: 14,
                          ),

                          // description
                          Container(
                            padding: const EdgeInsets.only(left: 22, right: 22),
                            alignment: Alignment.center,
                            child: Text(
                              document['specification'] ?? '-',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // address
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                const Icon(Icons.place_outlined),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: Text(
                                    document['Hospital'] ?? '-',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),

                          // phone number
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                const Icon(Icons.phone_in_talk),
                                const SizedBox(
                                  width: 11,
                                ),
                                TextButton(
                                  onPressed: () {
                                    _launchCaller("${document['phone']}");
                                  },
                                  child: Text(
                                    document['phone'] ?? '-',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),

                          // working hour
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.access_time_rounded),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    'Working Hours',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    document['openHour'] +
                                        " - " +
                                        document['closeHour'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          document['bio'] == null
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "About Doctor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Text(
                                      document['bio'] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),

                          const SizedBox(
                            height: 40,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Button(
                              width: double.infinity,
                              title: 'Book Appoinment',
                              disable: false,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                      doctorUid: document['id'],
                                      doctor: document['name'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // direct call
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 30),
                          //       height: 50,
                          //       // width: MediaQuery.of(context).size.width,
                          //       child: ElevatedButton(
                          //         style: ElevatedButton.styleFrom(
                          //           elevation: 2,
                          //           primary: Colors.indigo.withOpacity(0.9),
                          //           onPrimary: Colors.black,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(32.0),
                          //           ),
                          //         ),
                          //         onPressed: () {
                          //           _launchCaller(document['phone']);
                          //         },
                          //         child: const Icon(Icons.call),
                          //       ),
                          //     ),
                          //     Container(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 30),
                          //       height: 50,
                          //       // width: MediaQuery.of(context).size.width,
                          //       child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             elevation: 2,
                          //             primary: Colors.indigo.withOpacity(0.9),
                          //             onPrimary: Colors.black,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(32.0),
                          //             ),
                          //           ),
                          //           onPressed: () {
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                   builder: (context) => ChatRoom(
                          //                     user2Id: document['id'] ?? ' ',
                          //                     user2Name: document['name'] ?? ' ',
                          //                     profileUrl:
                          //                         document['profilePhoto'] ?? ' ',
                          //                   ),
                          //                 ));
                          //           },
                          //           child: const Icon(Icons
                          //               .message_outlined)), /* Text(
                          //           'Message',
                          //           style: GoogleFonts.lato(
                          //             color: Colors.white,
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold,
                          //           ), */
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Rating extends StatelessWidget {
  const Rating({
    Key? key,
    required this.rating,
  }) : super(key: key);

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < rating.toInt(); i++)
          const Icon(
            Icons.star_rounded,
            color: Colors.greenAccent,
            size: 35,
          ),
        if (rating - rating.toInt() > 0)
          const Icon(
            Icons.star_half_rounded,
            color: Colors.greenAccent,
            size: 35,
          ),
        if (5 - rating.ceil() > 0)
          for (var i = 0; i < 5 - rating.ceil(); i++)
            const Icon(
              Icons.star_rounded,
              color: Colors.black12,
              size: 30,
            ),
      ],
    );
  }
}
