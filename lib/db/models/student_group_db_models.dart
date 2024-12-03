class StudentGroupDBModels {
  StudentGroupDBModels({
    this.id,
    required this.studentId,
    required this.groupId,
    this.studentGroupStatus = 0,
    required this.startDate,
  });

  late int? id;
  late int studentId;
  late int groupId;
  late int studentGroupStatus;
  late int startDate;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['group_id'] = groupId;
    map['student_id'] = studentId;
    map['starting_date'] = startDate;
    return map;
  }

  Map<String, dynamic> toOneMap() {
    final map = <String, dynamic>{};
    map['studentGroupId'] = groupId;
    map['studentGroupStatus'] = studentGroupStatus;
    return map;
  }

  StudentGroupDBModels.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    studentId = map['student_id'];
    groupId = map['group_id'];
    startDate = map['starting_date'];
  }
}
