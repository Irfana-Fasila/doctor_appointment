import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:DocTime/components/button.dart';

class AppoinmentBooked extends StatelessWidget {
  const AppoinmentBooked({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Lottie.asset('assets/Images/successful.json'),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'Successfully Booked',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Button(
                width: double.infinity,
                title: 'Back to Home Page',
                disable: false,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    'main', (Route<dynamic> route) => false)),
          )
        ],
      )),
    );
  }
}
