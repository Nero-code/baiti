import 'dart:io';
import 'package:baiti/animations/slidefade_anime.dart';
import 'package:baiti/screens/add_student.dart';
import 'package:baiti/screens/student_info.dart';
import 'package:baiti/widgets/listViewItem.dart';
import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  var db = StudentsDB(dataBaseName: 'DataBase');
  late AlertDialog deleteDialog;

  _MainPageState() {
    print("mount point 1");
    deleteDialog = AlertDialog(
      title: Text("تأكيد الحذف؟"),
      content: Text("سيتم حذف جميع بيانات اﻷشخاص المحددين, هل أنت متأكد؟"),
      actions: [
        TextButton(
          child: Text("نعم"),
          onPressed: () {
            isChecked.sort((a, b) => b.compareTo(a));
            for (int i in isChecked) {
              deleteStudent(people[i]);
              people.removeAt(i);
            }
            setState(() {
              isChecked.clear();
              multiCheckEnabled = false;
            });
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("لا"),
          onPressed: () {
            //do nothing...
            Navigator.pop(context);
          },
        ),
      ],
    );
    fetchData();
  }

  List<Student> people = [];
  List<Payments> payments = [];
  List<int> isChecked = [];

  bool multiCheckEnabled = false;
  bool isSearchEnabled = false;
  bool rtl = true;
  //
  Future<void> fetchData() async {
    List<Student> pe = await db.getAllStudents();
    List<Payments> py = await db.getAllPayment();
    setState(() {
      people = pe;
      payments = py;
    });
    print("people: $people");
    print("payments: $payments");
  }

  void saveStudent() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentPage(),
      ),
    );
    if (res == null) return;
    setState(() {
      people.add(res);
      print("res in mainpage: $res");
    });
  }

  void addPayment(int i) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentInfo(
          student: people[i],
          pList: getStudentPayments(
            people[i].id,
          ),
          db: db,
          rtl: rtl,
        ),
      ),
    );
    print(res);
    if (res == null) return;
    setState(() {
      for (Payments i in res) payments.add(i);
    });
  }

  void deleteStudent(Student s) async {
    print("deleting student's payments...");
    for (var i in payments) {
      if (i.id == s.id) {
        await db.deletePayment(i);
      }
    }
    payments = await db.getAllPayment();
    print("finished! deleting student...");
    await db.deleteStudent(s);
    print("DONE!");
  }

  // @override
  // void initState() {
  //   fetchData();

  //   super.initState();
  // }

  List<Payments> getStudentPayments(int studentId) {
    List<Payments> temp = [];

    print("payments: $payments");
    for (var i in payments) {
      if (i.id == studentId) {
        temp.add(i);
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // if (people.isEmpty) fetchData();
    return WillPopScope(
      onWillPop: () async {
        if (multiCheckEnabled) {
          setState(() {
            isChecked.clear();
            multiCheckEnabled = false;
          });
        } else
          Navigator.of(context).pop(true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              splashRadius: 25,
              onPressed: () => {
                setState(() {
                  print("is Search Enabled: $isSearchEnabled");
                })
              },
              icon: Icon(
                Icons.search,
              ),
            ),
            AnimatedOpacity(
              opacity: isSearchEnabled ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: IconButton(
                splashRadius: 25,
                onPressed: multiCheckEnabled
                    ? () => showDialog(
                          context: context,
                          builder: (_) => deleteDialog,
                          barrierDismissible: false,
                        )
                    : saveStudent,
                icon: multiCheckEnabled
                    ? Icon(Icons.delete)
                    : Icon(
                        Icons.person_add_alt_rounded,
                      ),
              ),
            ),
          ],
          title: multiCheckEnabled ? Text("${isChecked.length}") : Text("بيتي"),
        ),
        body: Container(
          child: people.isNotEmpty
              ? ListView(
                  children: [
                    for (int i = 0; i < people.length; i++)
                      SimpleListItem(
                        id: i,
                        title: people[i].name,
                        subTitle: people[i].year,
                        leading: Icon(
                          Icons.rounded_corner,
                          size: 30,
                        ),
                        rtl: rtl,
                        isChecked: isChecked.contains(i),
                        checkMode: multiCheckEnabled,
                        onLongPressed: () {
                          setState(() {
                            multiCheckEnabled = !multiCheckEnabled;
                            if (!multiCheckEnabled) //multiCheck = false
                              isChecked.clear();
                            else //                   multiCheck = true
                              setState(() {
                                isChecked.add(i);
                              });
                          });
                        },
                        onPressed: () {
                          setState(() {
                            if (multiCheckEnabled) {
                              if (isChecked.contains(i)) {
                                isChecked.remove(i);
                                if (isChecked.isEmpty)
                                  setState(() {
                                    multiCheckEnabled = false;
                                  });
                              } else
                                isChecked.add(i);
                            } else
                              addPayment(i);
                          });
                        },
                      )
                  ],
                )
              : Center(
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لا يوجد عناصر لعرضها اضغط ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.person_add_alt_1,
                        size: 25,
                      ),
                      Text(
                        " لإضافة المزيد",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
