import 'package:baiti/widgets/paymentCard.dart';
import 'package:flutter/material.dart';
import '../widgets/dataBase_helper.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({
    Key? key,
    required this.student,
    required this.pList,
    required this.db,
    this.rtl = true,
  }) : super(key: key);
  final Student student;
  final bool rtl;
  final List<Payments> pList;
  final StudentsDB db;

  @override
  State<StudentInfo> createState() => _StudentInfoState(
        student: student,
        rtl: rtl,
        pList: pList,
        db: db,
      );
}

class _StudentInfoState extends State<StudentInfo> {
  Student student;
  List<Payments> pList, changesList = [];
  bool rtl;
  StudentsDB db;

  bool expandPayAdd = false;

  final valueCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  _StudentInfoState({
    required this.student,
    required this.pList,
    required this.rtl,
    required this.db,
  });

  Future<void> savePayment() async {
    if (valueCtrl.text.isEmpty) {
      return;
    }
    var temp = Payments(
      date: DateTime.now().toString().substring(0, 19),
      id: student.id,
      payment: double.parse(valueCtrl.text),
      description: descriptionCtrl.text,
    );
    await db.insertPayment(
      userId: temp.id,
      payment: temp.payment,
      description: temp.description,
      dateTime: temp.date,
    );
    setState(() {
      pList.add(temp);
      changesList.add(temp);
      expandPayAdd = false;
    });
    valueCtrl.clear();
    descriptionCtrl.clear();
  }

  void func(int i) {
    setState(
      () {
        db.deletePayment(pList[i]);
        pList.remove(pList[i]);
        print("object $i");
        print("payments: $pList");
      },
    );
  }

  @override
  void dispose() {
    valueCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(changesList);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  expandPayAdd = !expandPayAdd;
                });
              },
              icon: Icon(expandPayAdd ? Icons.cancel : Icons.my_library_add),
              splashRadius: 25,
            ),
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${student.name}"),
              Text(
                "${student.year}",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Column(
              textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${student.motherName} :اسم الام",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  "${student.university} :التخصص",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  "${student.nationalId} :الرقم الوطني",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              curve: Curves.easeInOutExpo,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              duration: Duration(milliseconds: 500),
              height: expandPayAdd ? 230 : 1,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "اضافة دفعة",
                      style: TextStyle(),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "قيمة الدفعة",
                    ),
                    keyboardType: TextInputType.number,
                    controller: valueCtrl,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "الوصف",
                    ),
                    controller: descriptionCtrl,
                  ),
                  SizedBox(
                    height: 18.5,
                  ),
                  ElevatedButton(
                    onPressed: savePayment,
                    child: Text(
                      "حفظ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.4),
                    ),
                  ),
                ],
              ),
            ),
            if (pList.isNotEmpty)
              for (int i = 0; i < pList.length; i++)
                InkWell(
                  child: PaymentCard(payment: pList[i]),
                ),
          ],
        ),
      ),
    );
  }
}
