class StudentAndGroupModels {
  StudentAndGroupModels({
    required this.studentsId,
    required this.groupId,
    required this.studentName,
    required this.studentSurName,
    required this.studentGroupStatus,
    this.isSelected = false,
  });

  int studentsId;
  int groupId;
  String studentName;
  String studentSurName;
  int studentGroupStatus;
  bool isSelected;

  // Метод для создания экземпляра из карты
  StudentAndGroupModels.fromMap(Map<String, dynamic> map)
      : studentsId = map['id'],
        groupId = map['group_id'],
        studentName = map['studentName'],
        studentSurName = map['studentSurName'],
        studentGroupStatus = map['studentGroupStatus'],
        isSelected = map['studentGroupStatus'] == 1 ? true : false;

  // Метод copyWith для создания нового экземпляра с измененными параметрами
  StudentAndGroupModels copyWith({bool? isSelected}) {
    return StudentAndGroupModels(
      studentsId: studentsId,
      groupId: groupId,
      studentName: studentName,
      studentSurName: studentSurName,
      studentGroupStatus: studentGroupStatus,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  toString() {
    return 'StudentAndGroupModels(studentsId: $studentsId, groupId: $groupId, studentName: $studentName, studentSurName: $studentSurName'
        ' studentGroupStatus: $studentGroupStatus,  isSelected: $isSelected)';
  }
}
