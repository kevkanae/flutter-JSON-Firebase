import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Jsondata>> fetchData() async {
  final response =
      await http.get(Uri.https('jsonplaceholder.typicode.com', '/todos'));

  if (response.statusCode == 200) {
    return compute(parseData, response.body);
  } else {
    throw Exception('Failed :(');
  }
}

// A function that converts a response body into a List<Photo>.
List<Jsondata> parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Jsondata>((json) => Jsondata.fromJson(json)).toList();
}

class Jsondata {
  int userId;
  int id;
  String title;
  bool completed;

  Jsondata({this.userId, this.id, this.title, this.completed});

  factory Jsondata.fromJson(Map<String, dynamic> json) {
    return Jsondata(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
