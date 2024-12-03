import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/repositories/models/student_model.dart';
import 'package:TeamLead/repositories/student_list_repository.dart';
import 'package:flutter/material.dart';

class GeneralListOfStudents extends StatefulWidget {
  const GeneralListOfStudents({
    super.key,
  });

  @override
  State<GeneralListOfStudents> createState() => _GeneralListOfStudentsState();
}

class _GeneralListOfStudentsState extends State<GeneralListOfStudents> {
  final String userDefaultImage = "assets/muaythai/mthai.svg";
  final String userImage = "assets/images/aka.jpg";

  List<StudentModel>? _user;

  @override
  void initState() {
    _loadStudentList();
    super.initState();
  }

  _loadStudentList() async {
    _user = await StudentListRepository().getStudentsList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: _user!.length,
              separatorBuilder: (context, int index) => const Divider(),
              itemBuilder: (context, i) {
                final student = _user![i];
                final String userName = student.name;
                final String userEmail = student.name;
                return ListTile(
                  // leading: CircleAvatar(
                  //     child: ClipOval(child: Image.asset('userImage', width: 60, height: 60,)),
                  //   ),
                  leading: const Icon(
                    Icons.account_circle,
                    size: 60,
                  ),
                  // leading: SvgPicture.asset(
                  //   userDefaultImage,
                  //   width: 45,
                  //   height: 45,
                  // ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  title: Text(userName,
                      style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text(userEmail,
                      style: Theme.of(context).textTheme.bodySmall),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteName.oneStudentView,
                      arguments: userName,
                    );
                  },
                );
              },
            ),
    );
  }
}
