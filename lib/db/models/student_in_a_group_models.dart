class StudentInAGroupModels {
  late int id;
  late int studentId;
  late int groupId;
  late String studentName;
  late String studentSurName;
  String? studentPhone;
  String? studentParentsFio;
  String? studentParentsPhone;
  String? studentImg;  
  late int studentPayStatus;
  late int startingDate;
  late int? lastPaymentInGroup;
  late int lastPaymentDateTimeStamp;

  StudentInAGroupModels.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    studentId = map["studentId"];
    groupId = map["groupId"];
    studentName = map["studentName"];
    studentSurName = map["studentSurName"];
    studentPhone = map["studentPhone"];
    studentParentsFio = map["studentParentsFio"];
    studentParentsPhone = map["studentParentsPhone"];
    studentImg = map["studentImg"];  
    studentPayStatus = map["studentPayStatus"];
    startingDate = map["startingDate"];
    lastPaymentInGroup = map["lastPaymentInGroup"];
    lastPaymentDateTimeStamp = map["lastPaymentDateTimeStamp"] ?? 0;
  }

  @override
  String toString() {
    return 'StudentInAGroupModels('
        'id: $id, '
        'studentId: $studentId, '
        'groupId: $groupId, '
        'studentName: $studentName, '
        'studentSurName: $studentSurName, '
        'studentPhone: $studentPhone, '
        'studentParentsFio: $studentParentsFio, '
        'studentParentsPhone: $studentParentsPhone, '
        'studentImg: $studentImg, '  
        'studentPayStatus: $studentPayStatus, '
        'startingDate: $startingDate, '
        'lastPaymentInGroup: $lastPaymentInGroup, '
        'lastPaymentDateTimeStamp: $lastPaymentDateTimeStamp'
        ')';
  }
}
