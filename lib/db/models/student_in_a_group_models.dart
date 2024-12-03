class StudentInAGroupModels {
  late int id;
  late int studentId;
  late int groupId;
  late String studentName;
  late String studentSecondName;
  late String studentSurName;
  late String studentPhone;
  late String? studentImg;
  late int studentPayStatus;
  late int? studentGroupId;
  late String studentGroupName;
  late int startingDate;
  late int? lastPaymentInGroup;
  late int lastPaymentDateTimeStamp;

  StudentInAGroupModels.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    studentId = map["student_id"];
    studentName = map["studentName"];
    studentSecondName = map["studentSecondName"];
    studentSurName = map["studentSurName"];
    studentPhone = map["studentPhone"];
    studentPayStatus = map["studentPayStatus"];
    studentImg = map["studentImg"];
    groupId = map["group_id"];
    lastPaymentInGroup = map['forWhichGroupId'];
    startingDate = map['starting_date'];
    lastPaymentDateTimeStamp = map['timestamp_seconds'] ?? 00;
  }

  @override
  String toString() {
    return 'StudentInAGroupModels(id: $id, studentId: $studentId, '
        'studentName: $studentName, studentSecondName: $studentSecondName,'
        ' studentSurName: $studentSurName,  studentPhone: $studentPhone, '
        'studentPayStatus: $studentPayStatus,groupId: $groupId, startingDate: $startingDate, '
        'lastPaymentInGroup: $lastPaymentInGroup, lastPaymentDateTimeStamp: $lastPaymentDateTimeStamp)';
  }
}
