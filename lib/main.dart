import 'package:baiti/screens/loginScreen.dart';
import 'package:baiti/screens/mainPage.dart';
import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // from here we will check the user state if he's
  // logged in or not. then navigate to the proper screen.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baiti',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Login(
        title: "Baiti",
      ),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController textController = TextEditingController();
  bool isLoggedIn = true;
  var db = StudentsDB(dataBaseName: 'baiti.db');

  Future<void> holdOn() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      holdOn();
    }

    return Scaffold(
      body: LoginScreen(),
    );
  }
}
