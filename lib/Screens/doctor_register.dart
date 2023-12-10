import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:DocTime/components/button.dart';
import 'package:lottie/lottie.dart';

import '../utils/globals.dart' as globals;

class DoctorSignUp extends StatefulWidget {
  const DoctorSignUp({super.key});

  @override
  State<DoctorSignUp> createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _docName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _docIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool obsecurepass = true;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'You can easily sign up,and connect to the Patients nearby you',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                _signUp(context),
                const Spacer(),
                const SizedBox(
                  height: 18,
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/');
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  Widget _signUp(context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              focusNode: f1,
              controller: _docName,
              keyboardType: TextInputType.name,
              cursorColor: Colors.greenAccent,
              decoration: const InputDecoration(
                hintText: "Username",
                labelText: "Username",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.person_outline),
                prefixIconColor: Colors.greenAccent,
              ),
              onFieldSubmitted: (value) {
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter the Name';
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              focusNode: f2,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.greenAccent,
              decoration: const InputDecoration(
                hintText: "Email Address",
                labelText: "Email",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Colors.greenAccent,
              ),
              onFieldSubmitted: (value) {
                f2.unfocus();
                if (_passwordController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f3);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Email';
                } else if (!emailValidate(value)) {
                  return 'Please enter correct Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              focusNode: f3,
              controller: _docIdController,
              keyboardType: TextInputType.name,
              cursorColor: Colors.greenAccent,
              decoration: const InputDecoration(
                hintText: "NMC Register Id",
                labelText: "Doctor id",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.numbers_outlined),
                prefixIconColor: Colors.greenAccent,
              ),
              onFieldSubmitted: (value) {
                f3.unfocus();
                if (_passwordController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f4);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) return 'Please Doctor NMC id';
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                focusNode: f4,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.greenAccent,
                obscureText: obsecurepass,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  prefixIconColor: Colors.greenAccent,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurepass = !obsecurepass;
                      });
                    },
                    icon: obsecurepass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Colors.greenAccent,
                          ),
                  ),
                ),
                onFieldSubmitted: (value) {
                  f4.unfocus();
                  if (_passwordConfirmController.text.isEmpty) {
                    FocusScope.of(context).requestFocus(f5);
                  }
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Password';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  } else {
                    return null;
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              focusNode: f5,
              controller: _passwordConfirmController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Colors.greenAccent,
              obscureText: obsecurepass,
              decoration: InputDecoration(
                hintText: "Confirm password",
                labelText: "Confirm",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Colors.greenAccent,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecurepass = !obsecurepass;
                    });
                  },
                  icon: obsecurepass
                      ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                      : const Icon(
                          Icons.visibility_outlined,
                          color: Colors.greenAccent,
                        ),
                ),
              ),
              onFieldSubmitted: (value) {
                f5.unfocus();
              },
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Password';
                } else if (value.compareTo(_passwordController.text) != 0) {
                  return 'Password not Matching';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Button(
              width: double.infinity,
              title: "Sign Up",
              disable: false,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showLoaderDialog(context);
                  _registerAccount(context);
                }
                // Navigator.of(context).pushNamed("main");
              },
            )
          ],
        ));
  }

//email checking with reg expression
  bool emailValidate(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  //show loading
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //register doctor
  void _registerAccount(context) async {
    User? user;
    UserCredential? credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (error) {
      if (error.toString().compareTo(
              '[firebase_auth/email-already-in-use] The email address is already in use by another account.') ==
          0) {
        showAlertDialog(context);
      }
    }
    user = credential!.user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateDisplayName(_docName.text);

      String name = 'Dr. ${_docName.text}';
      String accountType = 'pending_doctor';
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'type': accountType,
        'email': user.email,
      }, SetOptions(merge: true));

      // set data according to type doctor
      Map<String, dynamic> mp = {
        'RegisterId': _docIdController.text,
        'id': user.uid,
        'type': accountType,
        'name': name,
        'birthDate': null,
        'experince': null,
        'email': user.email,
        'phone': null,
        'bio': null,
        'Hospital': null,
        'profilePhoto': null,
        'openHour': "09:00",
        'closeHour': "21:00",
        'rating': double.parse(
            (3 + Random().nextDouble() * 1.9).toStringAsPrecision(2)),
        'specification': null,
        'specialization': 'general',
      };

      if (true) {
        // mp.addAll({
        //   'openHour': "09:00",
        //   'closeHour': "21:00",
        //   'rating': double.parse(
        //       (3 + Random().nextDouble() * 1.9).toStringAsPrecision(2)),
        //   'specification': null,
        //   'specialization': 'general',
        // });
        globals.isvari = true;
      }

      // sep
      FirebaseFirestore.instance.collection(accountType).doc(user.uid).set(mp);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('main', (Route<dynamic> route) => false);
    } else {}
  }

  //already user dialog box
  showAlertDialog(BuildContext context) {
    Navigator.pop(context);
    // set up the button
    Widget okButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(f2);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Error!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: 120,
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Email already Exists",
              ),
              Flexible(
                child: Lottie.asset(
                  'assets/Images/errdoctor.json',
                  // width: 150,
                  // height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        okButton,
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
}
