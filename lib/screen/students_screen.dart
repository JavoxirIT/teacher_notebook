import 'package:TeamLead/navigation/drawer_menu.dart';
import 'package:TeamLead/widgets/search.dart';
import 'package:TeamLead/widgets/student_list/general_list_of_students.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ВСЕ УЧЕНИКИ",
        ),
      ),
      drawer: const DrawerMenu(),
      body: const Column(
        children: [
          SearchBarComponents(),
          Expanded(
            child: SizedBox(
              // height: 200.0,
              child: GeneralListOfStudents(),
            ),
          ),
        ],
      ),
    );
  }
}
