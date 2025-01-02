class StudentDB {
  StudentDB( {
    this.id,
    required this.studentName,
    required this.studentSecondName,
    required this.studentSurName,
    required this.studentBrithDay,
    this.studentAddres  = "Не указано",
    required this.studentPhone,
    this.studentSchoolAndClassNumber = "Не указано",
    this.studentDocumentNomer = "Не указано",
    this.studentImg,
    required this.studentPayStatus,
    this.studentParentsFio = "Не указано",
    this.studentParentsPhone = "Не указано",
    this.studentGroupId = 0,
    this.studentGroupStatus = 0,
    this.studentGroupName = "Не указано",
  });

  final int? id;
  final String studentName;
  final String studentSecondName;
  final String studentSurName;
  final String? studentBrithDay;
  final String? studentAddres;
  final String studentPhone;
  final String? studentSchoolAndClassNumber;
  final String? studentDocumentNomer;
  final String? studentImg;
  final int studentPayStatus;
  final String? studentParentsFio;
  final String? studentParentsPhone;
  final int? studentGroupId;
  final String? studentGroupName;
  final int? studentGroupStatus;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["studentName"] = studentName;
    map["studentSecondName"] = studentSecondName;
    map["studentSurName"] = studentSurName;
    map["studentBrithDay"] = studentBrithDay;
    map["studentAddres"] = studentAddres;
    map["studentPhone"] = studentPhone;
    map["studentPayStatus"] = studentPayStatus;
    map["schoolAndClassNumber"] = studentSchoolAndClassNumber;
    map["studentDocumentNomer"] = studentDocumentNomer;
    map["studentParentsFio"] = studentParentsFio;
    map["studentParentsPhone"] = studentParentsPhone;
    map["studentImg"] = studentImg;
    map["studentGroupId"] = studentGroupId;
    map["studentGroupStatus"] = studentGroupStatus;
    return map;
  }

 factory StudentDB.fromMap(Map<String, dynamic> map) {
    return StudentDB(
    id: map["id"],
    studentName: map["studentName"],
    studentSecondName: map["studentSecondName"],
    studentSurName: map["studentSurName"],
    studentBrithDay: map["studentBrithDay"],
    studentAddres: map["studentAddres"],
    studentPhone: map["studentPhone"],
    studentPayStatus: map["studentPayStatus"],
    studentSchoolAndClassNumber: map["schoolAndClassNumber"],
    studentDocumentNomer: map["studentDocumentNomer"],
    studentParentsFio: map["studentParentsFio"],
    studentParentsPhone: map["studentParentsPhone"],
    studentImg: map["studentImg"],
    // studentGroupId =
    //     map["studentGroupId"] != null ? map["studentGroupId"] : 0;
    studentGroupId: map["studentGroupId"],
    studentGroupStatus: map["studentGroupStatus"],
    // studentGroupName = map["name"];
    );
  }
  @override
  String toString() {
    return 'StudentDB(id: $id, studentName: $studentName, studentSecondName: $studentSecondName, studentSurName: $studentSurName '
        'studentBrithDay: $studentBrithDay, studentAddres: $studentAddres, studentPhone: $studentPhone, studentPayStatus: $studentPayStatus '
        ' studentSchoolAndClassNumber: $studentSchoolAndClassNumber, studentDocumentNomer: $studentDocumentNomer, studentParentsFio: $studentParentsFio '
        'studentParentsPhone: $studentParentsPhone,  studentGroupId: $studentGroupId, studentGroupStatus: $studentGroupStatus)';
  }
}
