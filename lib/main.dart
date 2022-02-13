import 'package:flutter/material.dart';
import 'package:project/Screens/SignUp_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext ct) {
    return MaterialApp(
      home: SignUpScreen(),
      theme: ThemeData(primaryColor: Colors.blue),
    );
  }
}
