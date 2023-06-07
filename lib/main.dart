import 'package:flutter/material.dart';
import 'package:asankajayashan/login_screen.dart';
import 'package:asankajayashan/home_screen.dart';
import 'package:asankajayashan/profile_view.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileViewScreen(),
      },
    );
  }
}
