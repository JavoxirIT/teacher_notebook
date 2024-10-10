import 'package:assistant/db/models/student_bd_models.dart';
import 'package:assistant/db/models/student_in_a_group_models.dart';
import 'package:assistant/widgets/form/payments_form.dart';
import 'package:assistant/widgets/view/one_student_payments_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayAndAddPayOneStudent extends StatefulWidget {
  const PayAndAddPayOneStudent({Key? key}) : super(key: key);

  @override
  _PayAndAddPayOneStudentState createState() => _PayAndAddPayOneStudentState();
}

class _PayAndAddPayOneStudentState extends State<PayAndAddPayOneStudent> {
  var _userData;
  int? _studentId;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    if (setting.arguments is StudentDB) {
      _userData = setting.arguments as StudentDB;
      _studentId = _userData.id;
    } else if (setting.arguments is StudentInAGroupModels) {
      _userData = setting.arguments as StudentInAGroupModels;
      _studentId = _userData.studentId;
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
          // title: const Text('Title'),
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
            PaymentsForm(_userData),
            OneStudentPaymentsData(_studentId!),
          ],
        ),
      ),
    );
  }
}
