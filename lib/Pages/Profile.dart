import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  final String leURL;
  Profile(this.leURL);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = FirebaseAuth.instance.currentUser;
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference reference = FirebaseStorage.instance.ref().child("images/");
  final ImagePicker picker = ImagePicker();
  var downImg;
  var currentImage;
  String newName = FirebaseAuth.instance.currentUser.displayName;
  String url = FirebaseAuth.instance.currentUser.photoURL;
  final cont = TextEditingController(
      text: '${FirebaseAuth.instance.currentUser.displayName}');

  @override
  void initState() {
    currentImage = widget.leURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                        radius: 90,
                        backgroundImage: FileImage(File(currentImage)),
                      ),
                      onTap: () async {
                        PickedFile myImage =
                            await picker.getImage(source: ImageSource.gallery);
                        if (myImage != null) {
                          UploadTask uploadTask =
                              reference.putFile(File(myImage.path));
                          uploadTask.whenComplete(() async {
                            downImg = await reference.getDownloadURL();
                          }).catchError((onError) {
                            print(onError);
                          });
                          user.updateProfile(photoURL: await downImg);
                          user.reload();
                          setState(() {
                            currentImage = myImage.path;
                            print(currentImage.toString());
                          });
                        }
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
      ),
    );
  }
}
