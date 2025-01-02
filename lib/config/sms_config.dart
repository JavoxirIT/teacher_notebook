class SMSConfig {
  static const String apiKey = 'YOUR_SMS_API_KEY';
  static const String apiUrl = 'YOUR_SMS_API_URL';
  
  // Шаблоны сообщений
  static String getAttendanceMessage({
    required String studentName,
    required String status,
    required String date,
    String? comment,
  }) {
    String message = 'Уважаемые родители! ';
    
    switch (status) {
      case 'present':
        message += '$studentName присутствовал(а) на занятии.';
        break;
      case 'absent':
        message += '$studentName отсутствовал(а) на занятии.';
        break;
      case 'late':
        message += '$studentName опоздал(а) на занятие.';
        break;
      default:
        message += '$studentName: статус посещения: $status';
    }
    
    message += '\nДата: $date';
    if (comment != null && comment.isNotEmpty) {
      message += '\nКомментарий: $comment';
    }
    
    return message;
  }
}
