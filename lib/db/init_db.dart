import 'dart:io';

import 'package:TeamLead/db/constants/student_check_constants.dart';
import 'package:TeamLead/db/constants/student_create_group_constant.dart';
import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/constants/student_insert_group.dart';
import 'package:TeamLead/db/constants/student_pays_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class InitDB {
  InitDB();

  static Database? _dataBase;

  Future<Database?> get database async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await _initDB();
    return _dataBase;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/Student.db';

    final result = await openDatabase(
      path,
      version: 2, // Увеличили версию
      onCreate: _createDB,
      // onUpgrade: _onUpgrade,
    );

    return result;
  }

  void _createDB(Database db, int version) async {
    // Создание таблиц
    await db.execute(
      'CREATE TABLE $studentTable($studentId INTEGER PRIMARY KEY AUTOINCREMENT, $studentName TEXT, $studentSurName TEXT, $studentSecondName TEXT, $studentBrithDay TEXT, $studentAddres TEXT, $studentPhone TEXT, $studentSchoolAndClassNumber TEXT, $studentDocumentNomer TEXT, $studentParentsFio TEXT, $studentParentsPhone TEXT, $studentPayStatus INTEGER, $studentImg TEXT, $studentGroupId INTEGER, $studentGroupStatus INTEGER NOT NULL DEFAULT 0)',
    );
    await db.execute(
        'CREATE TABLE $groupTable($groupId INTEGER PRIMARY KEY AUTOINCREMENT, $groupName VARCHAR, $groupTimes VARCHAR, $groupDays INTEGER, $groupPrice INTEGER NOT NULL DEFAULT 0)');
    await db.execute(
        'CREATE TABLE $checkStudentTable($checkId INTEGER PRIMARY KEY AUTOINCREMENT, $checkYourId INTEGER, $checkDate VARCHAR, $checkStatusCheck INTEGER, $studentGroupId INTEGER )');
    await db.execute(
        'CREATE TABLE $paysTable($paysId INTEGER PRIMARY KEY AUTOINCREMENT, $paysStudentID INTEGER, $day VARCHAR, $month VARCHAR, $year VARCHAR, $paysSumma INTEGER, $timestampSeconds INTEGER, $forWhichGroupId INTEGER )');
    await db.execute(
      'CREATE TABLE $studentsInAGroupTable($studentsInAGroupId INTEGER PRIMARY KEY AUTOINCREMENT, $studentsInAGroupStudentId INTEGER, $studentsInAGroupGroupId INTEGER, $studentsInAGroupStartingDate INTEGER)',
    );
  }

  void deleteDatabaseFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/Student.db';
    if (await File(path).exists()) {
      await File(path).delete();
      print("Старая база данных удалена.");
    }
  }

  // void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 3) {
  //     // Добавляем столбец timestamp_seconds
  //     await db.execute(
  //       'ALTER TABLE $paysTable ADD COLUMN $timestampSeconds INTEGER',
  //     );
  //
  //     // Добавляем столбец forWhichGroupId
  //     await db.execute(
  //       'ALTER TABLE $paysTable ADD COLUMN $forWhichGroupId INTEGER',
  //     );
  //
  //     // Добавляем столбец studentsInAGroupStartingDate
  //     await db.execute(
  //       'ALTER TABLE $studentsInAGroupTable ADD COLUMN $studentsInAGroupStartingDate INTEGER',
  //     );
  //   }
  //   debugPrint("Database structure updated.");
  // }
}
