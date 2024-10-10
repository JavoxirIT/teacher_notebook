class StudentGroupDBModels {
  late int? id;
  late int studentId;
  late int groupId;
  StudentGroupDBModels({
    this.id,
    required this.studentId,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['group_id'] = groupId;
    map['student_id'] = studentId;
    return map;
  }
  
    Map<String, dynamic> toOneMap() {
    final map = <String, dynamic>{};
    map['studentGroupId'] = groupId;
    return map;
  }

  StudentGroupDBModels.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    studentId = map['student_id'];
    groupId = map['group_id'];
  }
}
