import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/widgets/form/payments_form.dart';
import 'package:TeamLead/widgets/form/attendance_form.dart';
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
  String? _groupName;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    if (setting.arguments is Map<String, dynamic>) {
      Map<String, dynamic> data = setting.arguments as Map<String, dynamic>;
      _userData = data['dataStudent'] as StudentInAGroupModels;
      _studentId = _userData.studentId;
      _groupId = data['groupId'];
      _groupName = data['groupName'] as String?;
    }
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
          actions: [
            IconButton(
              icon: const Icon(Icons.how_to_reg),
              onPressed: () {
                if (_groupId != null && _groupName != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceForm(
                        groupId: _groupId!,
                        groupName: _groupName!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Информация о группе недоступна'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              tooltip: 'Отметить посещаемость',
            ),
          ],
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
            PaymentsForm(
              userData: _userData,
              groupId: _groupId!,
              studentId: _studentId!,
            ),
            OneStudentPaymentsData(studentId: _studentId!),
          ],
        ),
      ),
    );
  }
}
