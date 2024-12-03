import 'dart:developer';

import 'package:TeamLead/db/constants/student_create_group_constant.dart';
import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/constants/student_insert_group.dart';
import 'package:TeamLead/db/constants/student_pays_constants.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/one_student_in_groups.dart';
import 'package:TeamLead/db/models/student_and_group_models.dart';
import 'package:TeamLead/db/models/student_group_db_models.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class StudentAddGroupRepository extends InitDB {
  static final StudentAddGroupRepository db = StudentAddGroupRepository();
  final List<StudentGroupDBModels> groupList = [];
  final List<StudentAndGroupModels> groupAndStudentList = [];
  final List<StudentInAGroupModels> studentInAgroup = [];
  final List<OneStudentInGroups> oneStudentInGroup = [];

  /// Добавляет студента в указанную группу, если он ещё не состоит в группе.
  /// Возвращает добавленную запись или `null`, если студент уже в группе.
  Future<StudentGroupDBModels?> addStudentToGroup(
      StudentGroupDBModels data) async {
    Database? db = await database;

    // Проверяем, существует ли студент в группе
    final isAlreadyInGroup =
        await _isStudentInGroup(data.studentId, data.groupId);
    if (isAlreadyInGroup) {
      debugPrint(
          'Студент с ID ${data.studentId} уже добавлен в группу с ID ${data.groupId}.');
      return null;
    }

    // Добавляем студента в таблицу studentsInAGroup
    try {
      data.id = await db!.insert(studentsInAGroupTable, data.toMap());

      // Обновляем данные группы для студента в таблице Students
      await db.update(
        studentTable,
        data.toOneMap(),
        where: '$studentId = ?',
        whereArgs: [data.studentId],
      );

      return data;
    } catch (e) {
      debugPrint('Ошибка при добавлении студента в группу: $e');
      return null;
    }
  }

  /// Проверяет, состоит ли студент в указанной группе.
  Future<bool> _isStudentInGroup(int studentId, int groupId) async {
    Database? db = await database;

    final result = await db!.query(
      studentsInAGroupTable,
      where: '$studentsInAGroupStudentId = ? AND $studentsInAGroupGroupId = ?',
      whereArgs: [studentId, groupId],
    );

    return result.isNotEmpty;
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
    final List<Map<String, dynamic>> data = await db!.rawQuery('''
        SELECT 
          $studentTable.studentName, 
          $studentTable.studentSurName, 
          $studentTable.studentSecondName,
          $studentTable.studentPhone,
          $studentTable.studentImg, 
          $studentTable.studentPayStatus, 
          $studentsInAGroupTable.student_id, 
          $studentsInAGroupTable.id, 
          $studentsInAGroupTable.group_id, 
          $studentsInAGroupTable.starting_date, 
          $paysTable.timestamp_seconds,
          $paysTable.forWhichGroupId 
        FROM $studentsInAGroupTable 
        INNER JOIN $studentTable 
          ON $studentTable.id = $studentsInAGroupTable.student_id 
        LEFT JOIN (
          SELECT forWhichGroupId, student_id, MAX(timestamp_seconds) AS timestamp_seconds
          FROM $paysTable
          WHERE forWhichGroupId = $id
          GROUP BY forWhichGroupId, student_id
        ) AS $paysTable
          ON $paysTable.forWhichGroupId = $studentsInAGroupTable.group_id 
          AND $paysTable.student_id = $studentsInAGroupTable.student_id
        WHERE $studentsInAGroupTable.group_id = $id
      ''');
    // debugPrint("data: $data");
    //
    // final List<Map<String, dynamic>> pay = await db!.rawQuery('''
    //   SELECT *
    //   FROM $paysTable
    //   WHERE forWhichGroupId = $id
    // ''');
    // debugPrint('Simple Query pays: $pay');
    for (var element in data) {
      // log(' Future<List<StudentInAGroupModels>> queryOneGroup: ${element}');
      studentInAgroup.add(StudentInAGroupModels.fromMap(element));
    }
    // log('${studentInAgroup.toString()}');
    return studentInAgroup;
  }

  Future<int> deleteStudentFromGroup(int id, int studentId) async {
    Database? db = await database;
    final updateUserTable = await db!.update(
      studentTable,
      {"studentGroupId": 0, "studentGroupStatus": 0},
      where: '$studentId = ?',
      whereArgs: [studentId],
    );

    log('updateUserTable: $updateUserTable');
    return await db.delete(
      studentsInAGroupTable,
      where: '$studentsInAGroupId = ?',
      whereArgs: [id],
    );
  }

  //
  Future<List<OneStudentInGroups>> getDataOneStudentInGroup(
    int studentId,
  ) async {
    oneStudentInGroup.clear();

    Database? db = await database;

    // Шаг 1: Получить все group_id для данного studentId из таблицы studentsInAGroupTable
    final List<Map<String, dynamic>> groupIdsResult = await db!.rawQuery('''
    SELECT $studentsInAGroupGroupId 
    FROM $studentsInAGroupTable WHERE $studentsInAGroupStudentId = ?;''',
        [studentId]);
    // Шаг 2: Если есть группы, запросить информацию о группах из groupTable
    if (groupIdsResult.isNotEmpty) {
      for (var group in groupIdsResult) {
        int groupId = group['group_id']; // Получаем group_id

        // Теперь выполняем запрос для получения информации о группе по groupId
        final List<Map<String, dynamic>> groupDetails = await db.rawQuery('''
        SELECT $groupTable.group_id, $groupTable.name, $groupTable.price
        FROM $groupTable
        WHERE $groupTable.group_id = ?;
      ''', [groupId]);
        // // Если группа найдена, добавляем ее в список
        if (groupDetails.isNotEmpty) {
          for (var item in groupDetails) {
            oneStudentInGroup.add(OneStudentInGroups.fromMap(item));
          }
        }
      }
    }
    return oneStudentInGroup;
  }
}
