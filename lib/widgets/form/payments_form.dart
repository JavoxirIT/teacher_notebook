import 'dart:developer';

import 'package:TeamLead/bloc/student_bloc/student_bloc.dart';
import 'package:TeamLead/db/models/one_student_in_groups.dart';
// import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/models/payments_db_models.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/db/payments_repository.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/show_cupertino_modal_popup.dart';
import 'package:TeamLead/widgets/show_snak_bar.dart';
import 'package:TeamLead/widgets/table_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PaymentsForm extends StatefulWidget {
  const PaymentsForm({
    required this.userData,
    required this.groupId,
    required this.studentId,
    super.key,
  });
  final StudentInAGroupModels userData;
  final int groupId;
  final int studentId;

  @override
  PaymentsFormState createState() => PaymentsFormState();
}

class PaymentsFormState extends State<PaymentsForm> {
  DateTime date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _payValue = TextEditingController();
  final _dateValue = TextEditingController();

  String? day;
  String? month;
  String? year;
  int? timestampSeconds;
  int _selectedGroup = 0;

  List<OneStudentInGroups> oneStudentInGroup = [];

  @override
  void dispose() {
    _payValue.dispose();
    _dateValue.dispose();

    super.dispose();
  }

  @override
  void initState() {
    getStudentListGroup(widget.studentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //       '${widget._userData.studentSurName} ${widget._userData.studentName}'),
        //   centerTitle: true,
        // ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _payValue,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: _payValue.text != ""
                          ? const Icon(Icons.delete_forever_outlined)
                          : const SizedBox(),
                      onTap: () {
                        _payValue.clear();
                      },
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 23.0, top: 15.0, bottom: 15.0),
                    labelText: "Введите сумму",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.parse(value) < 1) {
                      return "Заполните поле";
                    }
                    return null;
                  },
                ),
              ),
              widget.groupId == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          showCupModalPopup(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 32.0,
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    _selectedGroup = selectedItem;
                                  });
                                },
                                children: List<Widget>.generate(
                                  oneStudentInGroup.length,
                                  (int index) {
                                    return Center(
                                      child: Text(
                                        oneStudentInGroup[index].groupName,
                                        style: const TextStyle(
                                          color: colorGreen,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              context,
                              500);
                        },
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Виберите группу"),
                            Text(oneStudentInGroup.isNotEmpty
                                ? oneStudentInGroup[_selectedGroup].groupName
                                : ""),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              const Gap(10.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    showCupModalPopup(
                        CupertinoDatePicker(
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              date = newDate;
                              var info = DateFormat('dd/MM/yyyy')
                                  .format(newDate)
                                  .split("/");
                              day = info[0];
                              month = info[1];
                              year = info[2];
                              timestampSeconds =
                                  newDate.millisecondsSinceEpoch ~/ 1000;
                            });
                          },
                        ),
                        context,
                        500);
                  },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Виберите дату"),
                      Text(DateFormat('dd/MM/yyyy').format(date)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showModal(_payValue.text, _dateValue.text);
                      } else {
                        showSnackInfoBar(context, 'Сначала добавьте данные');
                      }
                    },
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(15.0)),
                    ),
                    child: const Text('Принять'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getStudentListGroup(int id) async {
    oneStudentInGroup =
        await StudentAddGroupRepository.db.getDataOneStudentInGroup(id);
    setState(() {});
  }

  Future<void> _showModal(pay, date) async {
    var info = DateFormat('dd/MM/yyyy').format(DateTime.now()).split("/");
    String days = info[0];
    String months = info[1];
    String years = info[2];
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Пожалуйста проверьте данные!",
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Table(
              children: <TableRow>[
                tableRow(context, "Сумма оплаты:", pay),
                tableRow(context, "Дата оплаты:",
                    '${day ?? days}/${month ?? months}/${year ?? years}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: clearButtonStyle,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Нет"),
            ),
            ElevatedButton(
              onPressed: () {
                formSubmit();
                Navigator.of(context).pop(true);
                // Navigator.of(context).pushNamed(RouteName.localStudent);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  void formSubmit() async {
    var info = DateFormat('dd/MM/yyyy').format(date).split("/");
    String days = info[0];
    String months = info[1];
    String years = info[2];
    int timestampSecondsDefault = date.millisecondsSinceEpoch ~/ 1000;
    // log("payments: ${int.parse(_payValue.text)}");
    // log("studentId: ${widget._userData.id!}");
    _formKey.currentState?.save();
    try {
      String result = await PaysRepository().insertStudentPayments(
        PaymentsDB(
          payments: int.parse(_payValue.text),
          day: day ?? days,
          month: month ?? months,
          year: year ?? years,
          studentId: widget.studentId,
          timestampSeconds: timestampSeconds ?? timestampSecondsDefault,
          forWhichGroupId:
              widget.groupId ?? oneStudentInGroup[_selectedGroup].groupId,
        ),
      );

      if (result == "success") {
        showSnackInfoBar(context, 'Данные сохранены');
        BlocProvider.of<StudentBloc>(context).add(StudentEventLoad());
      }
      if (result == "error") {
        showSnackInfoBar(context, 'Ошибка при сохранении');
      }
    } catch (e) {
      log("error: $e");
    }
  }
}
