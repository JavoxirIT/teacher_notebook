import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
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
  Future<List<StudentDB>> searchStudent(String input) async {
    studentsList.clear();
    Database? db = await database;
    // Подготавливаем строку поиска с подстановочными символами
    final searchQuery = '%$input%';

    // SQL-запрос для поиска студентов
    final sql = '''
    SELECT * 
    FROM $studentTable
    WHERE $studentSecondName LIKE ? 
       OR $studentName LIKE ? 
       OR $studentSurName LIKE ?
  ''';

    // Выполнение запроса с передачей параметров
    final result =
        await db!.rawQuery(sql, [searchQuery, searchQuery, searchQuery]);
    if (result.isNotEmpty) {
      for (var element in result) {
        studentsList.add(StudentDB.fromMap(element));
      }
    }
    return studentsList;
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
