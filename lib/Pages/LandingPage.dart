import 'package:flutter/material.dart';
import 'package:k1/Components/RoundedButton.dart';
import 'package:k1/Pages/LoginPage.dart';
import 'package:k1/Pages/Register.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                'W E L C O M E',
                style: TextStyle(fontSize: 30),
              )),
            ),
            SizedBox(
              height: 30.0,
            ),
            RoundedButton(
              title: 'Login',
              color: Color(0xffaee1e1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            Divider(
              thickness: 2,
              indent: 50,
              endIndent: 50,
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Register',
              color: Color(0xffaee1e1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
