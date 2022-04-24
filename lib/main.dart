import 'package:baiti/screens/mainPage.dart';
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
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.purple.shade800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.podcasts,
            color: Colors.amber,
            size: 40,
          ),
          SizedBox(
            height: 30,
          ),
          // Card Widget Start Point
          !isLoggedIn
              ? Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x33ffffff),
                          offset: Offset(-5, -5),
                          blurRadius: 7),
                      BoxShadow(
                          color: Colors.purple.shade900,
                          offset: Offset(5, 5),
                          blurRadius: 10),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment(-0.9, 0.0),
                        child: Text(
                          "New Account:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Theme(
                        data: ThemeData(primarySwatch: Colors.amber),
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: ThemeData(primarySwatch: Colors.amber),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "password",
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(Colors.amber.value),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => MainPage())),
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                      ),
                    ],
                  ),
                )
              // Card widget end point
              : CircularProgressIndicator(
                  color: Colors.amber,
                ),
        ],
      ),
    ));
  }
}
