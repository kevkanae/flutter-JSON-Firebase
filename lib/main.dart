import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:k1/Pages/LandingPage.dart';

//https://jsonplaceholder.typicode.com/todos
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      home: LandingPage(),
    );
  }
}
