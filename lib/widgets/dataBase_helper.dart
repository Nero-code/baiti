import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

//  this file includes {}  dataBase

class Student {
  int id;
  int deleted;
  String name, motherName, university, year, nationalId;

  Student({
    required this.id,
    required this.name,
    required this.year,
    required this.university,
    required this.motherName,
    required this.nationalId,
    this.deleted = 0,
  });
  int get uid => id;
  int get udeleted => deleted;
  String get PersonName => name;
  String get uyear => year;
  String get uUniversity => university;
  String get uMotherName => motherName;
  String get uNationalId => nationalId;
  set uid(int value) {
    id = value;
  }

  set udeleted(int value) {
    deleted = value;
  }

  set PersonName(String value) {
    if (value.length <= 255) name = value;
  }

  set uyear(String value) {
    if (value.length <= 255) year = value;
  }

  set uUniversity(String value) {
    if (value.length <= 255) university = value;
  }

  set uMotherName(String value) {
    if (value.length <= 255) motherName = value;
  }

  set uNationalId(String value) {
    if (value.length <= 255) nationalId = value;
  }

  @override
  String toString() {
    return 'Student {id: $id, name: $name, age: $year}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'university': university,
      'motherName': motherName,
      'nationalid': nationalId,
      'deleted' : deleted
    };
  }
}

Student studentFromMap(Map<String, dynamic> studInfo) {
  return Student(
    year: studInfo['year'],
    name: studInfo['name'],
    id: studInfo['id'],
    motherName: studInfo['motherName'],
    university: studInfo['university'],
    nationalId: studInfo['nationalid'],
  );
}

class StudentsDB {
  final String dataBaseName;
  String dbPath = '';
  Database? db;

  StudentsDB({required this.dataBaseName}) {
    init();
  }

  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();

    dbPath = dir.path + "/" + dataBaseName;
    print('dbPath: $dbPath');
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (dbPath, version) {
        print("DataBase Created: ${dbPath.path}");
        dbPath.execute(
          'CREATE TABLE IF NOT EXISTS Student(id INTEGER PRIMARY KEY AUTOINCREMENT,deleted INTEGER, name TEXT, year TEXT, motherName TEXT, university TEXT, nationalid TEXT)',
        );
        dbPath.execute(
            'CREATE TABLE IF NOT EXISTS Payment(userId INTEGER,id INTEGER PRIMARY KEY AUTOINCREMENT, payment FLOAT, description TEXT, date TEXT)');
      },
    );
    print("init finished!");
  }

  Future<int?> insertStudent(Map<String, dynamic> p) async {
    print(db);
    var res = await db?.insert(
      'Student',
      p,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(res);
    return res;
  }

  Future<void> updateStudent(Student p) async {
    await db?.update(
      'Student',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<void> deleteStudent(Student p) async {
    await db?.update(
      'Student',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<List<Student>> getAllStudents() async {
    final List<Map<String, dynamic>>? maps = await db?.query('Student', where: "deleted = ?", whereArgs: [1]);
    final List<Student> student = [];
    if (maps != null) {
      maps.forEach((element) {
        student.add(studentFromMap(element));
        print("get all students element: $element");
      });
      return student;
    }
    return Future(() => []);
  }

  Future<List<Payments>> getAllPayment() async {
    final List<Map<String, dynamic>>? maps = await db?.query('Payment');
    final List<Payments> payments = [];
    if (maps != null) {
      maps.forEach((element) {
        payments.add(paymentFromMap(element));
      });
    }
    print("Payment in dataBase: $payments");
    return payments;
  }

  Future<List<Payments>> getPaymentsById(int id) async {
    final List<Map<String, dynamic>>? maps = await db?.query('Payment',
        where: "userId = ?", whereArgs: [id], orderBy: "date desc");
    final List<Payments> payments = [];
    if (maps != null) {
      maps.forEach((element) {
        payments.add(paymentFromMap(element));
      });
    }
    print("Payment in dataBase: $payments");
    return payments;
  }

  Payments paymentFromMap(Map<String, dynamic> p) {
    return Payments(
      date: p['date'],
      description: p['description'],
      id: p['userId'],
      payment: p['payment'],
      pid: p['id'],
    );
  }

  Future<int?> insertPayment({
    required int userId,
    required double payment,
    String description = '',
    required String dateTime,
  }) async {
    var res = await db?.insert(
      'Payment',
      {
        'userId': userId,
        'payment': payment,
        'description': description,
        'date': dateTime,
      },
    );
    print(res);
    return res;
  }

  Future<void> updatePayment(Payments p) async {
    await db?.update(
      'Payment',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.pid],
    );
  }

  Future<void> deletePayment(Payments p) async {
    await db?.delete(
      'Payment',
      where: 'date = ?',
      whereArgs: [p.date],
    );
  }
}

class Payments {
  String description, date;
  double payment;
  int id;
  int? pid;

  Payments({
    required this.date,
    this.description = '',
    this.pid,
    required this.id,
    required this.payment,
  });

  int get userId => id;
  double get pay => payment;
  String get Reason => description;
  String get pdate => date;
  set userId(int value) {
    id = value;
  }

  set pay(double value) {
    payment = value;
  }

  set Reason(String value) {
    if (value.length <= 255) description = value;
  }

  set pdate(String value) {
    date = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'description': description,
      'userId': id,
      'payment': payment,
    };
  }

  @override
  String toString() {
    return 'Payment {userId: $id, date: $date, payment: $payment, description: $description}';
  }
}
