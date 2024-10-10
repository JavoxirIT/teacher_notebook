// ignore_for_file: public_member_api_docs, sort_constructors_first
class StudentInAGroupModels {
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

  StudentInAGroupModels.fromMap(Map<String, dynamic> map) {
    studentId = map["id"];
    studentName = map["studentName"];
    studentSecondName = map["studentSecondName"];
    studentSurName = map["studentSurName"];
    studentPhone = map["studentPhone"];
    studentPayStatus = map["studentPayStatus"];
    studentImg = map["studentImg"];
    groupId = map["group_id"];
  }
}
