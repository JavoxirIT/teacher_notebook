import 'package:assistant/db/constants/student_create_group_constant.dart';
import 'package:assistant/db/constants/student_data_constants.dart';
import 'package:assistant/db/constants/student_insert_group.dart';
import 'package:assistant/db/init_db.dart';
import 'package:assistant/db/models/student_and_group_models.dart';
import 'package:assistant/db/models/student_group_db_models.dart';
import 'package:assistant/db/models/student_in_a_group_models.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class StudentAddGroupRepository extends InitDB {
  static final StudentAddGroupRepository db = StudentAddGroupRepository();
  final List<StudentGroupDBModels> groupList = [];
  final List<StudentAndGroupModels> groupAndStudentList = [];
  final List<StudentInAGroupModels> studentInAgroup = [];

  // INSERT
  Future<StudentGroupDBModels> addStudentToGroop(
      StudentGroupDBModels data) async {
    Database? db = await database;
    data.id = await db!.insert(studentsInAGroupTable, data.toMap());

    data.groupId = await db.update(studentTable, data.toOneMap(),
        where: '$studentId = ?', whereArgs: [data.studentId]);
    debugPrint('$data.toOneMap()');

    return data;
  }

  // READ
  Future<List<StudentGroupDBModels>> getDataGroup() async {
    groupList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentGroupData =
        await db!.query(studentsInAGroupTable);

    for (var element in studentGroupData) {
      groupList.add(StudentGroupDBModels.fromMap(element));
    }
    return groupList;
  }

  //ПОЛУЧАЕМ СПИСОК СТУДЕНТОВ И ДАННЫЕ ОДНОЙ ГРУППЫ ПО id
  Future<List<StudentAndGroupModels>> queryALL(int id) async {
    groupAndStudentList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> groupAndStudent = await db!.rawQuery(
        'SELECT * FROM  $studentTable, $groupTable where  $groupTable.group_id = $id');

    for (var element in groupAndStudent) {
      groupAndStudentList.add(StudentAndGroupModels.fromMap(element));
    }
    return groupAndStudentList;
  }

  // ПОЛУЧАЕМ ДАННЫЕ ОДНОЙ ГРУППЫ В КОТОРОМ ЕСТЬ СТУДЕНТЫ
  Future<List<StudentInAGroupModels>> queryOneGroup(int id) async {
    studentInAgroup.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> data = await db!.rawQuery(
        'SELECT  $studentTable.id, $studentTable.studentName, $studentTable.studentSurName, $studentTable.studentSecondName, $studentTable.studentPhone, $studentTable.studentImg, $studentTable.studentPayStatus, $studentsInAGroupTable.id, $studentsInAGroupTable.group_id FROM $studentsInAGroupTable inner join $studentTable  on  $studentTable.id = $studentsInAGroupTable.student_id where  $studentsInAGroupTable.group_id = $id');

    for (var element in data) {
      studentInAgroup.add(StudentInAGroupModels.fromMap(element));
    }
    return studentInAgroup;
  }
}
