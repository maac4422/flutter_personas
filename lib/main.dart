import 'package:app_personas/screens/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:app_personas/screens/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Personas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login()
    );
  }
}
