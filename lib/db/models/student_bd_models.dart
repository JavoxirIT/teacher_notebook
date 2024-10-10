class StudentDB {
  late int? id;
  late String studentName;
  late String studentSecondName;
  late String studentSurName;
  late String studentBrithDay;
  late String studentAddres;
  late String studentPhone;
  late String studentSchoolAndClassNumber;
  late String studentDocumentNomer;
  late String? studentImg;
  late int studentPayStatus;
  late String studentParentsFio;
  late String studentParentsPhone;
  late int? studentGroupId;
  late String studentGroupName;
  late bool? studentGroupStatus;

  StudentDB(
    this.id,
    this.studentName,
    this.studentSecondName,
    this.studentSurName,
    this.studentBrithDay,
    this.studentAddres,
    this.studentPhone,
    this.studentSchoolAndClassNumber,
    this.studentDocumentNomer,
    this.studentImg,
    this.studentPayStatus,
    this.studentParentsFio,
    this.studentParentsPhone,
    this.studentGroupId,
    this.studentGroupStatus,
  );

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

  StudentDB.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    studentName = map["studentName"];
    studentSecondName = map["studentSecondName"];
    studentSurName = map["studentSurName"];
    studentBrithDay = map["studentBrithDay"];
    studentAddres = map["studentAddres"];
    studentPhone = map["studentPhone"];
    studentPayStatus = map["studentPayStatus"];
    studentSchoolAndClassNumber = map["schoolAndClassNumber"];
    studentDocumentNomer = map["studentDocumentNomer"];
    studentParentsFio = map["studentParentsFio"];
    studentParentsPhone = map["studentParentsPhone"];
    studentImg = map["studentImg"];
    // studentGroupId =
    //     map["studentGroupId"] != null ? map["studentGroupId"] : 0;
    studentGroupId = map["studentGroupId"];
    studentGroupStatus = map["studentGroupStatus"];
    // studentGroupName = map["name"];
  }
}
