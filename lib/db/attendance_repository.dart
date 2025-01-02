import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceRepository extends InitDB {
  static final AttendanceRepository db = AttendanceRepository();

  // Создание таблицы
  Future<void> createTable(Database db) async {
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
        FOREIGN KEY (group_id) REFERENCES groups (id),
        UNIQUE(student_id, group_id, date)
      )
    ''');
  }

  // Проверка существования записи
  Future<bool> hasAttendanceRecord(int studentId, int groupId, String date) async {
    Database? db = await database;
    final result = await db!.query(
      'attendance',
      where: 'student_id = ? AND group_id = ? AND date = ?',
      whereArgs: [studentId, groupId, date],
    );
    return result.isNotEmpty;
  }

  // Обновление существующей записи
  Future<bool> updateAttendance(AttendanceDB attendance) async {
    try {
      Database? db = await database;
      debugPrint('Updating attendance for student ${attendance.studentId} on ${attendance.date}');
      
      // Преобразуем данные в Map и убираем id из обновления
      final map = attendance.toMap();
      map.remove('id'); // Убираем id из обновляемых полей
      
      final result = await db!.update(
        'attendance',
        map,
        where: 'student_id = ? AND group_id = ? AND date = ?',
        whereArgs: [attendance.studentId, attendance.groupId, attendance.date],
      );
      
      debugPrint('Update result: $result rows affected');
      return result > 0;
    } catch (e) {
      debugPrint('Error updating attendance: $e');
      return false;
    }
  }

  // Добавление или обновление записи о посещаемости
  Future<String> insertAttendance(AttendanceDB attendance) async {
    try {
      Database? db = await database;
      
      // Проверяем, существует ли уже запись на этот день
      final exists = await hasAttendanceRecord(
        attendance.studentId,
        attendance.groupId,
        attendance.date,
      );
      
      if (exists) {
        // Если запись существует, обновляем её
        debugPrint('Updating existing attendance record');
        final updated = await updateAttendance(attendance);
        return updated ? "success" : "error";
      } else {
        // Если записи нет, создаём новую
        debugPrint('Creating new attendance record');
        attendance.id = await db!.insert('attendance', attendance.toMap());
        return "success";
      }
    } catch (e) {
      debugPrint("Error inserting/updating attendance: $e");
      return "error";
    }
  }

  // Получение записей посещаемости для группы за определенную дату
  Future<List<AttendanceDB>> getGroupAttendance(int groupId, String date) async {
    Database? db = await database;
    
    debugPrint('Fetching attendance for groupId: $groupId, date: $date');
    
    final List<Map<String, dynamic>> results = await db!.rawQuery('''
      SELECT 
        a.id,
        a.student_id,
        a.group_id,
        a.date,
        a.status,
        a.comment,
        a.timestamp_seconds,
        a.is_notified,
        s.studentName,
        s.studentSurName,
        s.studentParentsPhone
      FROM attendance a
      JOIN students s ON a.student_id = s.id
      WHERE a.group_id = ? AND a.date = ?
    ''', [groupId, date]);
    
    debugPrint('Found ${results.length} records');
    
    return results.map((map) => AttendanceDB.fromMap(map)).toList();
  }

  // Получение записей посещаемости для группы за определенный месяц
  Future<List<AttendanceDB>> getMonthlyGroupAttendance(int groupId, String yearMonth) async {
    final dbClient = await database;
    debugPrint('Getting monthly attendance for group $groupId and month $yearMonth');
    
    final result = await dbClient!.query(
      'attendance',
      where: 'group_id = ? AND substr(date, 1, 7) = ?',
      whereArgs: [groupId, yearMonth],
      orderBy: 'date ASC',
    );
    
    debugPrint('Found ${result.length} attendance records');
    debugPrint('First record: ${result.isNotEmpty ? result.first : "no records"}');
    
    return result.map((json) {
      try {
        return AttendanceDB.fromMap(json);
      } catch (e) {
        debugPrint('Error parsing record: $e');
        debugPrint('Problematic record: $json');
        rethrow;
      }
    }).toList();
  }

  // Удаление дублирующихся записей
  Future<void> removeDuplicateRecords() async {
    Database? db = await database;
    
    // Получаем список дублирующихся записей
    final duplicates = await db!.rawQuery('''
      SELECT student_id, group_id, date, COUNT(*) as count
      FROM attendance
      GROUP BY student_id, group_id, date
      HAVING count > 1
    ''');

    // Для каждой группы дубликатов оставляем только последнюю запись
    for (var dup in duplicates) {
      final studentId = dup['student_id'];
      final groupId = dup['group_id'];
      final date = dup['date'];
      
      // Получаем все записи для этой комбинации
      final records = await db.query(
        'attendance',
        where: 'student_id = ? AND group_id = ? AND date = ?',
        whereArgs: [studentId, groupId, date],
        orderBy: 'timestamp_seconds DESC',
      );
      
      // Удаляем все записи кроме последней
      if (records.length > 1) {
        final latestId = records.first['id'];
        await db.delete(
          'attendance',
          where: 'student_id = ? AND group_id = ? AND date = ? AND id != ?',
          whereArgs: [studentId, groupId, date, latestId],
        );
        debugPrint('Removed ${records.length - 1} duplicate records for student $studentId on $date');
      }
    }
  }

  // Обновление статуса уведомления
  Future<void> updateNotificationStatus(int attendanceId) async {
    Database? db = await database;
    await db!.update(
      'attendance',
      {'is_notified': 1},
      where: 'id = ?',
      whereArgs: [attendanceId],
    );
  }

  // Получение статистики посещаемости студента
  Future<Map<String, int>> getStudentAttendanceStats(int studentId, int groupId) async {
    Database? db = await database;
    var results = await db!.rawQuery('''
      SELECT status, COUNT(*) as count
      FROM attendance
      WHERE student_id = ? AND group_id = ?
      GROUP BY status
    ''', [studentId, groupId]);
    
    Map<String, int> stats = {
      'present': 0,
      'absent': 0,
      'late': 0,
    };
    
    for (var row in results) {
      stats[row['status'] as String] = row['count'] as int;
    }
    
    return stats;
  }
}
