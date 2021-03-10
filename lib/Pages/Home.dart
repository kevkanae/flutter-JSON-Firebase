import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k1/Components/Parser.dart';
import 'package:k1/Pages/LandingPage.dart';
import 'package:k1/Pages/Profile.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  Reference reference = FirebaseStorage.instance.ref().child("images/");
  Future<List<Jsondata>> yoss;

  @override
  void initState() {
    super.initState();
    yoss = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe4fbff),
      appBar: AppBar(
        elevation: 21,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'T O D O',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xffaee1e1),
        actions: [
          InkWell(
            child: CircleAvatar(
              child: Icon(Icons.account_box),
              backgroundColor: Color(0xffe4fbff),
            ),
            onTap: () async {
              _fileFromImageUrl() async {
                String s = await reference.getDownloadURL();
                String str = s
                    .split('https://firebasestorage.googleapis.com')
                    .toSet()
                    .join('');
                var uri = Uri.https('firebasestorage.googleapis.com', str);
                final response = await http.get(uri);

                final documentDirectory =
                    await getApplicationDocumentsDirectory();
                final file =
                    File(join(documentDirectory.path, 'imagetest.png'));
                file.writeAsBytesSync(response.bodyBytes);
                String path = file.path;
                return path;
              }

              String leUrl = await _fileFromImageUrl();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(leUrl)));
            },
          ),
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              }),
        ],
      ),
      body: FutureBuilder(
        future: yoss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DisplayData(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.black,
          ));
        },
      ),
    );
  }
}

class DisplayData extends StatefulWidget {
  final List<Jsondata> mydata;
  DisplayData(this.mydata);
  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: widget.mydata.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .20,
                width: MediaQuery.of(context).size.width * .85,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  elevation: 21,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'User ID: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '${widget.mydata[index].userId}'),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'ID: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '${widget.mydata[index].id}'),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Title: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '${widget.mydata[index].title}'),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Completed: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: '${widget.mydata[index].completed}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
