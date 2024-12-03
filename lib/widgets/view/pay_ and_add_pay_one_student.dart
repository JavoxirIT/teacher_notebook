import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/widgets/form/payments_form.dart';
import 'package:TeamLead/widgets/view/one_student_payments_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayAndAddPayOneStudent extends StatefulWidget {
  const PayAndAddPayOneStudent({super.key});

  @override
  State<PayAndAddPayOneStudent> createState() => _PayAndAddPayOneStudentState();
}

class _PayAndAddPayOneStudentState extends State<PayAndAddPayOneStudent> {
  var _userData;
  int? _studentId;
  int? _groupId;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;

    if (setting.arguments is StudentDB) {
      _userData = setting.arguments as StudentDB;
      _studentId = _userData.id;
      // log('_PayAndAddPayOneStudentState StudentDB: ${_userData.id}');
    } else if (setting.arguments is Map<String, dynamic>) {
      Map<String, dynamic> data = setting.arguments as Map<String, dynamic>;
      _userData = data['dataStudent'] as StudentInAGroupModels;
      _studentId = _userData.studentId;
      _groupId = data['groupId'];
      // _userData = setting.arguments as StudentInAGroupModels;
      // log('_PayAndAddPayOneStudentState StudentInAGroupModels: ${_studentId}');
    }
    // _studentId = _userData.id;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Окно оплаты'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesomeIcons.userPlus, size: 14.0),
                child: Text(
                  "Окно оплаты",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.layerGroup, size: 14.0),
                child: Text(
                  "Все оплаты",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PaymentsForm(_userData, _groupId, _studentId!),
            OneStudentPaymentsData(studentId: _studentId!),
          ],
        ),
      ),
    );
  }
}
