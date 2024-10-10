class StudentModel {
  const StudentModel({
    required this.id,
    required this.name,
    required this.username,
  });
  final int id;
  final String name;
  final String username;
  
  
  //  Future<dynamic> getGlobalData() async {
  //   await NetworkHelper.getGlobalData().then((data) {
  //     print('Data: ${data.length}');
  //   });
  // }

  // factory StudentModel.fromJson(Map<String, dynamic> map) {
  //   return StudentModel(
  //     id: map['id'] as int,
  //     name: map['name'] as String,
  //     username: map['username'] as String
  //   );
  // }
  
}
