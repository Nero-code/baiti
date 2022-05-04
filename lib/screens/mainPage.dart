import 'dart:io';
import 'package:baiti/animations/slidefade_anime.dart';
import 'package:baiti/screens/add_student.dart';
import 'package:baiti/screens/student_info.dart';
import 'package:baiti/widgets/listViewItem.dart';
import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.db}) : super(key: key);

  final StudentsDB? db;
  @override
  State<MainPage> createState() => _MainPageState(db);
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AlertDialog deleteDialog;
  final db;
  _MainPageState(this.db) {
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
    fetchData(0);
  }

  List<Student> people = [];
  List<int> isChecked = [];

  bool multiCheckEnabled = false;
  bool isSearchEnabled = false;
  bool rtl = true;
  bool deletedStd = false;
  Future<void> fetchData(deleted) async {
    List<Student> pe = await db.getAllStudents(deleted);
    print("people: $pe");

    setState(() {
      people = pe;
    });
  }

  void saveStudent() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudentPage(db: db),
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
          db: db,
        ),
      ),
    );
  }

  void deleteStudent(Student s) async {
    s.deleted = 1;
    print(s.toMap());
    await db.deleteStudent(s);
  }

  @override
  Widget build(BuildContext context) {
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
                showSearch(context: context, delegate: SearchData(people, db))
              },
              icon: Icon(
                Icons.search,
              ),
            ),
            IconButton(
              splashRadius: 25,
              onPressed: () {
                setState(() {
                  deletedStd = !deletedStd;
                });
                if (deletedStd) {
                  fetchData(1);
                } else {
                  fetchData(0);
                }
              },
              icon: deletedStd
                  ? Icon(Icons.view_headline)
                  : Icon(Icons.delete_sweep),
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

class SearchData extends SearchDelegate<Student> {
  final List<Student> persons;
  final db;
  SearchData(this.persons, this.db);
  final List<Student> fList = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear),color: Colors.purple,),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Student std = Student(
              id: 0,
              name: "nodata",
              year: "0",
              university: "0",
              motherName: "motherName",
              nationalId: "nationalId");
          close(context, std);
        },
        color: Colors.purple,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
          
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.white,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: fList.map((e) {
                return SimpleListItem(
                  id: e.id,
                  subTitle: e.year,
                  leading: Icon(
                    Icons.rounded_corner,
                    size: 30,
                  ),
                  rtl: true,
                  title: e.name,
                  onLongPressed: () {},
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => StudentInfo(
                              student: e,
                              db: db,
                            )));
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggest =
        this.persons.where((element) => element.name.contains(query)).toList();
    fList.clear();
    for (int i = 0; i < suggest.length; i++) {
      fList.add(suggest[i]);
    }
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.person,color: Colors.purple,),
        title: Text(suggest[index].name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => StudentInfo(
                    student: suggest[index],
                    db: db,
                  )));
        },
      ),
      itemCount: suggest.length,
    );
  }
}
