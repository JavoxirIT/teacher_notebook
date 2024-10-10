import 'package:assistant/db/constants/student_data_constants.dart';
import 'package:assistant/db/init_db.dart';
import 'package:assistant/db/models/student_bd_models.dart';
import 'package:sqflite/sqflite.dart';

class StudentRepository extends InitDB {
  static final StudentRepository db = StudentRepository();

  late List<StudentDB> studentsLists;
  late final List<StudentDB> studentsList = [];

  // READ
  Future<List<StudentDB>> getStudents() async {
    studentsList.clear();
    Database? db = await database;
    // final List<Map<String, dynamic>> studentMapList =
    //     await db!.query(studentTable);
    // final List<Map<String, dynamic>> studentMapList = await db!.rawQuery(
    //     'SELECT  $studentTable.id, $studentTable.studentName, $studentTable.studentSecondName, $studentTable.studentSurName, $studentTable.studentBrithDay, $studentTable.studentAddres, $studentTable.studentPhone, $studentTable.schoolAndClassNumber, $studentTable.studentDocumentNomer, $studentTable.studentParentsFio, $studentTable.studentParentsPhone, $studentTable.studentPayStatus, $studentTable.studentImg, $studentTable.studentGroupId, $groupTable.name   FROM $groupTable inner join $studentTable on  $studentTable.studentGroupId = $groupTable.id');
    final List<Map<String, dynamic>> studentMapList =
        await db!.query(studentTable);

    for (var element in studentMapList) {
      studentsList.add(StudentDB.fromMap(element));
    }
    // if (studentsLists.isEmpty) return  studentsList;
    return studentsList;
  }

  // 'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.date, $paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id'

// INSERT
  Future<StudentDB> insertStudent(StudentDB student) async {
    Database? db = await database;
    student.id = await db!.insert(studentTable, student.toMap());
    return student;
  }

// UPDATE
  Future<int> updateStudent(StudentDB student) async {
    Database? db = await database;
    return await db!.update(
      studentTable,
      student.toMap(),
      where: '$studentId = ?',
      whereArgs: [student.id],
    );
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
  Future searchStudent(String input) async {
    // Database? db = await this.database;
    // final List<Map<String, dynamic>> studentMapList =
    //     await db!.query(studentTable);
    // final List<StudentDB> studentsList = [];
    // for (var element in studentMapList) {
    //   studentsList.add(StudentDB.fromMap(element));
    // }
    // matches.clear();
    studentsLists = studentsList.where((e) {
      return e.studentName.toLowerCase() == input.toLowerCase() ||
          e.studentSecondName.toLowerCase() == input.toLowerCase() ||
          e.studentSurName.toLowerCase() == input.toLowerCase();
    }).toList();
    return studentsLists;
  }
}
