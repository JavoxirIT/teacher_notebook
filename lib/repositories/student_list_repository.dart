import 'package:TeamLead/repositories/models/student_model.dart';
import 'package:dio/dio.dart';

class StudentListRepository {
  // static List<StudentModel> parse(responseBody) {
  //   final Map<String, dynamic> parsed = json.decode(responseBody);

  //   return List<StudentModel>.from(
  //       parsed["data"].map((x) => StudentModel.fromJson(x)));
  // }

  Future<List<StudentModel>> getStudentsList() async {
    final result =
        await Dio().get('https://jsonplaceholder.typicode.com/users');
    final response = result.data as List<dynamic>;
    final data = response
        .map((el) => StudentModel(
            id: (el as Map<String, dynamic>)['id'],
            name: (el)['name'],
            username: (el)['username']))
        .toList();
    // debugPrint(data.toString());
    return data;
  }
}
