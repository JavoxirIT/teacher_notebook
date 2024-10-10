import 'package:flutter/material.dart';
import 'package:assistant/widgets/search.dart';
import 'package:assistant/widgets/student_list/local_data_student_list.dart';
import 'package:assistant/navigation/drawer_menu.dart';

class StudentsLocalDBDatsScreen extends StatelessWidget {
  const StudentsLocalDBDatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Список всех учеников",
        ),
      ),
      drawer: const DrawerMenu(),
      body: const Column(
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
    );
  }
}
