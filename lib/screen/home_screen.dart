import 'dart:developer';

import 'package:TeamLead/db/payments_repository.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:TeamLead/navigation/drawer_menu.dart';
import 'package:TeamLead/widgets/group/group_list.dart';
import 'package:TeamLead/widgets/home_widgets/home_grid.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int studentCount = 0;
  int numberOfPaid = 0;
  int numberNotOfPaid = 0;
  Map<String, dynamic> currentMonthTotalPayments = {
    'total': 0,
    'month': 0,
    'year': 0
  };

  @override
  void initState() {
    getStudentCount();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27.0, vertical: 10.0),
                child: Text("Статистика"),
              ),
            ),
            HomeGrid(
                stCount: studentCount,
                numberOfPaid: numberOfPaid,
                numberNotOfPaid: numberNotOfPaid,
                currentMonthTotalPayments: currentMonthTotalPayments),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10.0),
                child: Text("Список групп"),
              ),
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 2, // Ограничение высоты
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GroupList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getStudentCount() async {
    // Анализируем платежи за декабрь 2024
    final now = DateTime.now();
    try {
      final results = await Future.wait([
        StudentRepository.db.getStudentCount(),
        StudentRepository.db.getStudentCountPay(),
        StudentRepository.db.getStudentCountNotPay(),
        PaysRepository.db.getCurrentMonthPaymentsSum(
          now.month.toString(),
          now.year.toString(),
        ),
      ]);

      studentCount = results[0] as int;
      numberOfPaid = results[1] as int;
      numberNotOfPaid = results[2] as int;
      currentMonthTotalPayments = results[3] as Map<String, dynamic>;

      setState(() {});
    } catch (e) {
      debugPrint('Error getting student counts: $e');
    }
  }
}
