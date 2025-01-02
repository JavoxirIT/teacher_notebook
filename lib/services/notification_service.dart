import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:TeamLead/config/sms_config.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<bool> sendAttendanceNotification({
    required String phoneNumber,
    required String studentName,
    required String status,
    required String date,
    String? comment,
  }) async {
    try {
      final message = SMSConfig.getAttendanceMessage(
        studentName: studentName,
        status: status,
        date: date,
        comment: comment,
      );

      final response = await http.post(
        Uri.parse(SMSConfig.apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SMSConfig.apiKey}',
        },
        body: jsonEncode({
          'phone': phoneNumber,
          'message': message,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
}
