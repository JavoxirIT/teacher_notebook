import 'package:flutter/cupertino.dart';

class AttendanceDB {
  int? id;
  final int studentId;
  final int groupId;
  final String date;
  final String status; // present, absent, late
  final String? comment;
  final int timestampSeconds;
  final bool isNotified; // флаг отправки уведомления
  
  // Эти поля не сохраняются в таблицу attendance
  final String? studentName;
  final String? studentSurName;
  final String? studentParentsPhone;

  AttendanceDB({
    this.id,
    required this.studentId,
    required this.groupId,
    required this.date,
    required this.status,
    this.comment,
    required this.timestampSeconds,
    this.isNotified = false,
    this.studentName,
    this.studentSurName,
    this.studentParentsPhone,
  });

  Map<String, dynamic> toMap() {
    // Возвращаем только поля, которые есть в таблице attendance
    final map = {
      'student_id': studentId,
      'group_id': groupId,
      'date': date,
      'status': status,
      'comment': comment,
      'timestamp_seconds': timestampSeconds,
      'is_notified': isNotified ? 1 : 0,
    };
    
    // Добавляем id только если он не null
    if (id != null) {
      map['id'] = id;
    }
    
    return map;
  }

  factory AttendanceDB.fromMap(Map<String, dynamic> map) {
    debugPrint('Creating AttendanceDB from map: $map');
    return AttendanceDB(
      id: map['id'],
      studentId: map['student_id'],
      groupId: map['group_id'],
      date: map['date'],
      status: map['status'],
      comment: map['comment'],
      timestampSeconds: map['timestamp_seconds'],
      isNotified: map['is_notified'] == 1,
      studentName: map['studentName'],
      studentSurName: map['studentSurName'],
      studentParentsPhone: map['studentParentsPhone'],
    );
  }
}
