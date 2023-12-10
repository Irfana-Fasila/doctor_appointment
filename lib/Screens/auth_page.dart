import 'package:DocTime/Screens/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:DocTime/components/Social_Button.dart';
import 'package:DocTime/components/login_form.dart';
import 'package:DocTime/components/signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIN = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
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
                    Spacer(),
                    isSignIN
                        ? Container()
                        : TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('doctorsignup');
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.userDoctor,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Register',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  isSignIN
                      ? "Sign in to your account"
                      : 'You can easily sign up,and connect to the Doctors nearby you',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                isSignIN ? LoginForm() : SignUpForm(),
                const SizedBox(
                  height: 15,
                ),
                isSignIN
                    ? Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPassword()),
                              );
                            },
                            child: const Text(
                              "Forgot Your Password?",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      )
                    : Container(),
                const Spacer(),
                SizedBox(
                  height: 18,
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isSignIN
                          ? "Don't have an account?"
                          : 'Already have an account?',
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
                        setState(() {
                          isSignIN = !isSignIN;
                        });
                      },
                      child: Text(
                        isSignIN ? "Sign Up" : "Sign In",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
