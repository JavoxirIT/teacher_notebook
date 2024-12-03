class PaymentsDB {
  PaymentsDB({
    this.paysId,
    required this.payments,
    required this.studentId,
    required this.day,
    required this.month,
    required this.year,
    required this.timestampSeconds,
    required this.forWhichGroupId,
  });
  late int? paysId;
  late String day;
  late String month;
  late String year;
  late int payments;
  late int studentId;
  late String studentSurName;
  late String studentName;
  late int? timestampSeconds;
  late int? forWhichGroupId;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["id"] = paysId;
    map["student_id"] = studentId;
    map["summa"] = payments;
    map['day'] = day;
    map['month'] = month;
    map['year'] = year;
    map['timestamp_seconds'] = timestampSeconds;
    map['forWhichGroupId'] = forWhichGroupId;
    return map;
  }

  PaymentsDB.fromMap(Map<String, dynamic> map) {
    paysId = map['id'];
    studentId = map['student_id'];
    payments = map['summa'];
    day = map['day'];
    month = map['month'];
    year = map['year'];
    studentSurName = map['studentSurName'];
    studentName = map['studentName'];
    timestampSeconds = map['timestamp_seconds'];
    forWhichGroupId = map['forWhichGroupId'];
  }

  @override
  toString() {
    return 'PaymentsDB(paysId: $paysId, payments: $payments, day: $day, month: $month, '
        'year: $year, studentId: $studentId, studentSurName: $studentSurName, '
        'studentName: $studentName, timestampSeconds: $timestampSeconds, forWhichGroupId: $forWhichGroupId)';
  }
}
