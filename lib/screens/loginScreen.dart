import 'package:baiti/screens/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final code1Ctrl = TextEditingController();
  final code2Ctrl = TextEditingController();

  final _node = FocusScopeNode();

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple,
            Colors.deepPurple.shade600,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0.0, -0.9),
              child: Icon(
                Icons.insert_emoticon_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.0),
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.white,
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
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'ادخل رقم الهاتف',
                            hintText: '0987654321',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          // textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'سوف تصلك رسالة تاكيد خلال بضع دقائق بعد ادخال رقم الهاتف',
                          textDirection: TextDirection.rtl,
                        ),
                        AnimatedOpacity(
                          opacity: isVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: FocusScope(
                            node: _node,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  child: TextField(
                                    controller: code1Ctrl,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      isDense: true,
                                    ),
                                    enabled: isVisible,
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    onChanged: (strVal) {
                                      if (strVal.length == 3) {
                                        print("strVal: $strVal,");
                                        _node.nextFocus();
                                      } else if (strVal.length > 3) {
                                        code2Ctrl.text = strVal.substring(3, 4);
                                        code1Ctrl.text = strVal.substring(0, 3);
                                        _node.nextFocus();
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  child: TextField(
                                    controller: code2Ctrl,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      isDense: true,
                                    ),
                                    enabled: isVisible,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    onChanged: (strVal) {
                                      if (strVal.length == 0) {
                                        _node.previousFocus();
                                      } else if (strVal.length > 3) {
                                        code2Ctrl.text = strVal.substring(0, 3);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // setState(() {
                              //   isVisible = !isVisible;
                              // });
                              // print(
                              //     "Debug: " + code1Ctrl.text + code2Ctrl.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MainPage()));
                            },
                            child: Text("تسجيل الدخول"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.0, 0.96),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Powered by '),
                    TextSpan(
                      text: 'DonaSoft',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
