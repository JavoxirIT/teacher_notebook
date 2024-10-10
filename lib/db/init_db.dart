import 'dart:io';
import 'package:assistant/db/constants/student_create_group_constant.dart';
import 'package:assistant/db/constants/student_check_constants.dart';
import 'package:assistant/db/constants/student_insert_group.dart';
import 'package:assistant/db/constants/student_pays_constants.dart';
import 'package:assistant/db/constants/student_data_constants.dart';
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

// INIT DB
  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}Student.db';
    final result = await openDatabase(path, version: 1, onCreate: _createDB);

    return result;
  }

// CREATE TABLE
  void _createDB(Database db, int version) async {
    //ТАБЛИЦА ДАННЫЕ СТУДЕНТОВ
    await db.execute(
        'CREATE TABLE $studentTable($studentId INTEGER PRIMARY KEY AUTOINCREMENT, $studentName TEXT, $studentSurName TEXT, $studentSecondName TEXT, $studentBrithDay TEXT, $studentAddres TEXT, $studentPhone TEXT, $studentSchoolAndClassNumber TEXT, $studentDocumentNomer TEXT, $studentParentsFio TEXT, $studentParentsPhone TEXT, $studentPayStatus INTEGER, $studentImg TEXT, $studentGroupId INTEGER NOT NULL DEFAULT "0", $studentGroupStatus BOOLEAN NOT NULL DEFAULT "0")');

    //ТАБЛИЦА ГРУППЫ
    await db.execute(
        'CREATE TABLE $groupTable($groupId INTEGER PRIMARY KEY AUTOINCREMENT, $groupName VARCHAR, $groupTimes VARCHAR, $groupDays INTEGER, $groupPrice INTEGER DEFAULT NOT NULL "0")');

    //ТАБЛИЦА ДЛЯ ОТМЕТКИ УЧИНИКА О ПОСЕЩЕНИЕ
    await db.execute(
        'CREATE TABLE $checkStudentTable($checkId INTEGER PRIMARY KEY AUTOINCREMENT, $checkYourId INTEGER, $checkDate VARCHAR, $checkStatusCheck INTEGER, $studentGroupId INTEGER )');
    //ТАБЛИЦА С ОПЛАТОЙ
    await db.execute(
        'CREATE TABLE $paysTable($paysId INTEGER PRIMARY KEY AUTOINCREMENT, $paysStudentID INTEGER, $paysDate VARCHAR, $paysSumma INTEGER )');

    //ТАБЛИЦА С СТУДЕНТАМИ В ГРУППАХ
    await db.execute(
      'CREATE TABLE $studentsInAGroupTable($studentsInAGroupId INTEGER PRIMARY KEY AUTOINCREMENT, $studentsInAGroupStudentId INTEGER, $studentsInAGroupGroupId INTEGER, $studentsInAGroupStartingDate VARCHAR)',
    );
  }
}
