import 'package:flutter/material.dart';
import 'package:ask_list_app/HomeScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task List App",
      home: HomeScreen(),
    );
  }
}
