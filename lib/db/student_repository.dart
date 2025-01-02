import 'dart:developer';

import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

enum DatabaseResult { success, error, databaseNotFound, duplicateEntry }

class DatabaseException implements Exception {
  final String message;
  final DatabaseResult result;

  DatabaseException(this.message, this.result);

  @override
  String toString() => message;
}

class StudentRepository extends InitDB {
  static final StudentRepository db = StudentRepository();

  late List<StudentDB> studentsLists;
  late final List<StudentDB> studentsList = [];

  // READ
  Future<List<StudentDB>> getStudents() async {
    studentsList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentMapList =
        await db!.query(studentTable);

    for (var element in studentMapList) {
      studentsList.add(StudentDB.fromMap(element));
    }
    return studentsList;
  }

  // 'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.date, $paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id'

// INSERT
  Future<DatabaseResult> insertStudent(StudentDB student) async {
    try {
      final db = await database;
      if (db == null) {
        throw DatabaseException(
            'Database not initialized', DatabaseResult.databaseNotFound);
      }

      final id = await db.insert(studentTable, student.toMap());

      if (id > 0) {
        debugPrint('Student inserted successfully with id: $id');
        return DatabaseResult.success;
      } else {
        throw DatabaseException(
            'Failed to insert student', DatabaseResult.error);
      }
    } catch (e) {
      debugPrint('Error inserting student: $e');
      if (e is DatabaseException) {
        rethrow;
      }
      throw DatabaseException('Database error: $e', DatabaseResult.error);
    }
  }

// UPDATE
  Future<DatabaseResult> updateStudent(StudentDB student) async {
    try {
      Database? db = await database;
      if (db == null) {
        throw DatabaseException(
            'Database not initialized', DatabaseResult.databaseNotFound);
      }
      final id = await db.update(
        studentTable,
        student.toMap(),
        where: '$studentId = ?',
        whereArgs: [student.id],
      );
      if (id > 0) {
        debugPrint('Student updated successfully with id: $id');
        return DatabaseResult.success;
      } else {
        throw DatabaseException(
            'Failed to update student', DatabaseResult.error);
      }
    } catch (e) {
      debugPrint('Error update student: $e');
      if (e is DatabaseException) {
        rethrow;
      }
      throw DatabaseException('Database error: $e', DatabaseResult.error);
    }
  }

// DELETE
  Future<int> deleteStudent(id) async {
    Database? db = await database;
    return await db!.delete(
      studentTable,
      where: '$studentId = ?',
      whereArgs: [id],
    );
  }

  // SEARCH
  Future<List<StudentDB>> searchStudent(String input) async {
    List<StudentDB> searchResults = [];
    try {
      Database? db = await database;
      final searchQuery = '%$input%';

      final sql = '''
    SELECT * 
    FROM $studentTable
    WHERE $studentSecondName LIKE ? 
       OR $studentName LIKE ? 
       OR $studentSurName LIKE ?
    ''';

      final result =
          await db!.rawQuery(sql, [searchQuery, searchQuery, searchQuery]);
      if (result.isNotEmpty) {
        for (var element in result) {
          searchResults.add(StudentDB.fromMap(element));
        }
      }
    } catch (e) {
      // Логирование ошибки
      debugPrint('Error during search: $e');
    }
    return searchResults;
  }

  // Метод для получения количества записей (пользователей)
  Future<int> getStudentCount() async {
    Database? db = await database;
    if (db == null) {
      return 0;
    }

    // Выполняем запрос для подсчета записей
    final countData = await db.rawQuery('SELECT COUNT(*) FROM $studentTable');

    // Извлекаем количество строк
    int count = Sqflite.firstIntValue(countData) ?? 0;

    return count;
  }

// Метод для получения количества учеников, обучающихся на платной основе
  Future<int> getStudentCountPay() async {
    Database? db = await database;

    if (db == null) {
      return 0;
    }

    // Выполняем запрос для подсчета учеников, обучающихся на платной основе
    final countData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $studentTable WHERE $studentPayStatus = 1');

    // Извлекаем количество строк
    int count = countData.isNotEmpty ? countData.first['count'] as int : 0;

    return count;
  }

  // Метод для получения количества учеников, обучающихся беспдатно
  Future<int> getStudentCountNotPay() async {
    Database? db = await database;
    if (db == null) {
      return 0;
    }
    // Выполняем запрос для подсчета учеников, обучающихся на платной основе
    final countData = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $studentTable WHERE $studentPayStatus = 0');
    // Извлекаем количество строк
    int count = countData.isNotEmpty ? countData.first['count'] as int : 0;

    return count;
  }
}
