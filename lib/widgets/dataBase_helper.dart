import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

//  this file includes {}  dataBase

class Student {
  final int id;
  final String name, motherName, university, year, nationalId;

  const Student({
    required this.id,
    required this.name,
    required this.year,
    required this.university,
    required this.motherName,
    required this.nationalId,
  });

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
    dbPath = path.join(await getDatabasesPath(), dataBaseName);
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (database, version) {
        print("DataBase Created: ${database.path}");
        database.execute(
          'CREATE TABLE IF NOT EXISTS Student(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, year TEXT, motherName TEXT, university TEXT, nationalid TEXT)',
        );
        database.execute(
            'CREATE TABLE IF NOT EXISTS Payment(userId INTEGER, payment FLOAT, description TEXT, date TEXT)');
      },
    );
  }

  Future<int?> insertStudent(Map<String, dynamic> p) async {
    var res = await db?.insert(
      'Student',
      p,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

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
    await db?.delete(
      'Student',
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<List<Student>> getAllStudents() async {
    final List<Map<String, dynamic>>? maps = await db?.query('Student');
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

  Payments paymentFromMap(Map<String, dynamic> p) {
    return Payments(
      date: p['date'],
      description: p['description'],
      id: p['userId'],
      payment: p['payment'],
    );
  }

  Future<void> insertPayment({
    required int userId,
    required double payment,
    String description = '',
    required String dateTime,
  }) async {
    await db?.insert(
      'Payment',
      {
        'userId': userId,
        'payment': payment,
        'description': description,
        'date': dateTime,
      },
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
  final String description, date;
  final double payment;
  final int id;

  const Payments({
    required this.date,
    this.description = '',
    required this.id,
    required this.payment,
  });

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
