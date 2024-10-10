class StudentAndGroupModels {
  late int studentsId;
  late int groupId;
  late String studentName;
  late String studentSurName;
  late bool? isSelected;

  StudentAndGroupModels({
    required this.studentsId,
    required this.groupId,
    required this.studentName,
    required this.studentSurName,
  });

  StudentAndGroupModels.fromMap(Map<String, dynamic> map) {
    groupId = map['group_id'];
    studentsId = map['id'];
    studentName = map['studentName'];
    studentSurName = map['studentSurName'];
    isSelected = false;
  }
}
