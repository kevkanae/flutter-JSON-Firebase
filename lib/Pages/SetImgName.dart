import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k1/Components/RoundedButton.dart';
import 'package:k1/Pages/LandingPage.dart';
import 'package:k1/Pages/Profile.dart';

import 'Home.dart';

class setDetails extends StatefulWidget {
  @override
  _setDetailsState createState() => _setDetailsState();
}

class _setDetailsState extends State<setDetails> {
  final _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  final ImagePicker picker = ImagePicker();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .45,
              width: MediaQuery.of(context).size.width,
              color: Color(0xffaee1e1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage('assets/images/user.jpeg')),
                    onTap: () async {
                      PickedFile myImage =
                          await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        user.updateProfile(photoURL: myImage.path);
                        if (myImage != null) {
                          isVisible = true;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  Text('Tap Image to Change Profile Pic'),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Visibility(
              child: RoundedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                title: 'Done',
                color: Color(0xffaee1e1),
              ),
              visible: isVisible,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            RoundedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              title: 'Sign Out',
              color: Color(0xffaee1e1),
            )
          ],
        ),
      ),
    );
  }
}
