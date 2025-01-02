import 'dart:io';
import 'dart:convert';
import 'package:TeamLead/db/constants/student_check_constants.dart';
import 'package:TeamLead/db/constants/student_create_group_constant.dart';
import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/constants/student_insert_group.dart';
import 'package:TeamLead/db/constants/student_pays_constants.dart';
import 'package:TeamLead/db/attendance_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class InitDB {
  InitDB();

  static Database? _dataBase;

  // Список таблиц для бэкапа
  final List<String> _tablesToBackup = [
    studentTable,
    groupTable,
    checkStudentTable,
    paysTable,
    studentsInAGroupTable,
  ];

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
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );

    return result;
  }

  // Создание бэкапа данных
  Future<Map<String, List<Map<String, dynamic>>>> _backupData(Database db) async {
    Map<String, List<Map<String, dynamic>>> backup = {};
    
    for (String table in _tablesToBackup) {
      try {
        List<Map<String, dynamic>> tableData = await db.query(table);
        backup[table] = tableData;
      } catch (e) {
        print('Ошибка при бэкапе таблицы $table: $e');
      }
    }
    
    return backup;
  }

  // Восстановление данных
  Future<void> _restoreData(Database db, Map<String, List<Map<String, dynamic>>> backup) async {
    for (String table in _tablesToBackup) {
      if (backup.containsKey(table)) {
        try {
          for (var row in backup[table]!) {
            await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        } catch (e) {
          print('Ошибка при восстановлении таблицы $table: $e');
        }
      }
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Создаем бэкап данных
      final backup = await _backupData(db);
      
      try {
        // Создаем таблицу attendance
        await db.execute('''
          CREATE TABLE IF NOT EXISTS attendance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id INTEGER NOT NULL,
            group_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            status TEXT NOT NULL,
            comment TEXT,
            timestamp_seconds INTEGER NOT NULL,
            is_notified INTEGER DEFAULT 0,
            FOREIGN KEY (student_id) REFERENCES students (id),
            FOREIGN KEY (group_id) REFERENCES groups (id)
          )
        ''');

        // Восстанавливаем данные
        await _restoreData(db, backup);
        
        print('База данных успешно обновлена до версии 3');
      } catch (e) {
        print('Ошибка при обновлении базы данных: $e');
        // В случае ошибки пытаемся восстановить данные
        await _restoreData(db, backup);
      }
    }
  }

  Future<void> _createDB(Database db, int version) async {
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
        'CREATE TABLE $studentsInAGroupTable($studentsInAGroupId INTEGER PRIMARY KEY AUTOINCREMENT, $studentsInAGroupStudentId INTEGER, $studentsInAGroupGroupId INTEGER, $studentsInAGroupStartingDate VARCHAR)');
    
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        group_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        comment TEXT,
        timestamp_seconds INTEGER NOT NULL,
        is_notified INTEGER DEFAULT 0,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (group_id) REFERENCES groups (id)
      )
    ''');
  }

  void deleteDatabaseFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/Student.db';
    if (await File(path).exists()) {
      await File(path).delete();
      print("Старая база данных удалена.");
    }
  }
}
