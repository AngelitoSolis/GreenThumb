import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:greenthumb/screens/login.dart';

class register extends StatefulWidget {
  register({
    super.key,
  });

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool _obscurePassword = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController first = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _register() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);
      String user_id = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection("Info").doc(user_id).set({
        'firstname': first.text,
        'lastname': last.text,
        'email': email.text,
      });
      Navigator.of(context).push(CupertinoPageRoute(builder: (ctx) => Login()));
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    "lib/images/logo.png",
                    height: 130,
                  ),
                ),
                Text(
                  "SignUp",
                  style: TextStyle(fontSize: 25),
                ),
                Gap(20),
                TextFormField(
                  controller: first,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(15),
                TextFormField(
                  controller: last,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(15),
                TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid email';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(15),
                TextFormField(
                  controller: password,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(15),
                TextFormField(
                  controller: confirm,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }

                    if (password.text != value) {
                      return 'Passwords do not match.';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
