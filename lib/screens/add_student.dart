import 'package:baiti/widgets/dataBase_helper.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final db = StudentsDB(dataBaseName: "DataBase");
  var nameCtrl = TextEditingController();
  var ageCtrl = TextEditingController();
  var motherNameCtrl = TextEditingController();
  var universityCtrl = TextEditingController();
  var nationalidCtrl = TextEditingController();

  void returnResult() async {
    if (nameCtrl.text.isEmpty ||
        ageCtrl.text.isEmpty ||
        motherNameCtrl.text.isEmpty ||
        universityCtrl.text.isEmpty ||
        nationalidCtrl.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    int? id = await db.insertStudent({
      'name': nameCtrl.text,
      'year': ageCtrl.text,
      'university': universityCtrl.text,
      'motherName': motherNameCtrl.text,
      'nationalid': nationalidCtrl.text,
    });
    var temp = Student(
        id: id as int,
        name: nameCtrl.text,
        year: ageCtrl.text,
        motherName: motherNameCtrl.text,
        university: universityCtrl.text,
        nationalId: nationalidCtrl.text);
    print("new Student: $temp");
    Navigator.pop(context, temp);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    universityCtrl.dispose();
    motherNameCtrl.dispose();
    nationalidCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: Text(
          'Add Student',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 40,
                  color: Colors.amber,
                ),
              ),
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: "اسم الطالب:",
                ),
                autofocus: true,
                controller: nameCtrl,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: "السنة الدراسية:",
                ),
                controller: ageCtrl,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              ),
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'اسم الأم:',
                ),
                controller: motherNameCtrl,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'التخصص:',
                ),
                controller: universityCtrl,
                textInputAction: TextInputAction.next,
              ),
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'الرقم الوطني:',
                ),
                controller: nationalidCtrl,
                textInputAction: TextInputAction.done,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  child: Text("حفظ"),
                  onPressed: returnResult,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
