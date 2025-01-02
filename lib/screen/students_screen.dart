import 'package:TeamLead/navigation/drawer_menu.dart';
import 'package:TeamLead/widgets/search.dart';
import 'package:TeamLead/widgets/student_list/local_data_student_list.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Список всех учеников",
        ),
      ),
      drawer: const DrawerMenu(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: const Column(
          children: [
            SearchBarComponents(),
            Expanded(
              child: SizedBox(
                // height: 200.0,
                child: LocalDataStudentList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
