import 'package:DocTime/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/globals.dart';

class UpdateUserDetails extends StatefulWidget {
  final String label;
  final String field;
  final String value;
  const UpdateUserDetails(
      {Key? key, required this.label, required this.field, required this.value})
      : super(key: key);

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final TextEditingController _textcontroller = TextEditingController();
  late FocusNode f1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? userID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
    userID = user!.uid;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    _textcontroller.text = widget.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        // back button
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Container(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: widget.label,
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.edit),
                  prefixIconColor: Colors.greenAccent,
                ),
                cursorColor: Colors.greenAccent,
                controller: _textcontroller,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onFieldSubmitted: (String data) {
                  _textcontroller.text = data;
                },
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter the ${widget.label}';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Button(
              width: double.infinity,
              title: "Update",
              disable: false,
              onPressed: () {
                FocusScope.of(context).unfocus();
                updateData();
                Navigator.of(context).pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    FirebaseFirestore.instance
        .collection(isDoctor ? 'doctor' : 'patient')
        .doc(userID)
        .set({
      widget.field: _textcontroller.text,
    }, SetOptions(merge: true));
    if (widget.field.compareTo('name') == 0) {
      await user!.updateDisplayName(_textcontroller.text);
    }
  }
}
