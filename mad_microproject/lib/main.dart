import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homepage.dart';
import 'register.dart';
import 'login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey[300], // navigation bar color
    statusBarColor: Colors.grey[300], // status bar color
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => const Login(),
      'register': (context) => const Register(),
      'studentInfo': (context) => StudentInfoApp(),
    },
  ));
}