import 'package:flutter/material.dart';
import 'package:k1/Components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k1/Pages/LandingPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Constants.dart';
import 'Home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  bool showSpinner = false;
  var email;
  var password;
  var downImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .75,
                  child: Center(
                      child: Text(
                    'R E G I S T E R',
                    style: TextStyle(fontSize: 30),
                  )),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .75,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration:
                        kTextFieldDec.copyWith(hintText: 'Enter Your Email'),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .75,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration:
                        kTextFieldDec.copyWith(hintText: 'Enter Your Password'),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  color: Color(0xffaee1e1),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      print(email);
                      print(password);
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          });
                        });
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code ==
                          'account-exists-with-different-credential') {
                        setState(() {
                          showSpinner = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('User Already Exists!'),
                          action: SnackBarAction(
                            label: 'Go Back',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LandingPage()),
                              );
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
