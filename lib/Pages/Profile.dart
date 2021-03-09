import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = FirebaseAuth.instance.currentUser;
  final ImagePicker picker = ImagePicker();
  String newName = FirebaseAuth.instance.currentUser.displayName;
  String url = FirebaseAuth.instance.currentUser.photoURL;
  final cont = TextEditingController(
      text: '${FirebaseAuth.instance.currentUser.displayName}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              color: Color(0xffaee1e1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: CircleAvatar(
                        radius: 90, backgroundImage: FileImage(File(url))),
                    onTap: () async {
                      PickedFile myImage =
                          await picker.getImage(source: ImageSource.gallery);
                      user.updateProfile(photoURL: myImage.path);
                      setState(() {
                        url = myImage.path;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Tap Image to Change Profile Pic')
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .7,
              child: TextField(
                controller: cont,
                onChanged: (val) {
                  setState(() {
                    newName = val;
                    user.updateProfile(displayName: newName);
                  });
                },
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width * .9,
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        'Name: ${newName ?? 'Add Name'}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            Container(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width * .9,
                child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text('E-Mail ID: ${user.email}',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
