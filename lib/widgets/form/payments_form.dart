import 'package:assistant/bloc/student_bloc/student_bloc.dart';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/db/payments_repository.dart';
// import 'package:assistant/db/models/student_bd_models.dart';
import 'package:assistant/db/models/payments_db_models.dart';
import 'package:assistant/style/clear_button_style.dart';
import 'package:assistant/theme/style_constant.dart';
import 'package:assistant/widgets/show_cupertino_modal_popup.dart';
import 'package:assistant/widgets/show_snak_bar.dart';
import 'package:assistant/widgets/table_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PaymentsForm extends StatefulWidget {
  const PaymentsForm(this._userData, {super.key});
  final _userData;

  @override
  PaymentsFormState createState() => PaymentsFormState();
}

class PaymentsFormState extends State<PaymentsForm> {
  DateTime date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _payValue = TextEditingController();
  final _dateValue = TextEditingController();

  @override
  void dispose() {
    _payValue.dispose();
    _dateValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //       '${widget._userData.studentSurName} ${widget._userData.studentName}'),
      //   centerTitle: true,
      // ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(
              child: Icon(
                Icons.account_balance_wallet_sharp,
                size: 110.0,
                color: colorGreen,
              ),
            ),
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
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: iconGreenColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelText: "Введите сумму",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: iconGreenColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == "" ? "Заполните поле" : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _dateValue,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      showCupModalPopup(
                        CupertinoDatePicker(
                          initialDateTime: date,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              date = newDate;
                              _dateValue.text =
                                  DateFormat.yMd().format(newDate);
                            });
                          },
                        ),
                        context,
                      );
                    },
                    child: const Icon(Icons.date_range),
                  ),
                  contentPadding: const EdgeInsets.only(
                      left: 23.0, top: 15.0, bottom: 15.0, right: 40),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: iconGreenColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelText: "Введите  дату",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: iconGreenColor),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == "" ? "Заполните поле" : null,
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
                    padding: MaterialStatePropertyAll(EdgeInsets.all(15.0)),
                  ),
                  child: const Text('Принять'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showModal(pay, date) async {
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
                tableRow(context, "Дата оплаты:", date),
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
                Navigator.of(context).pushNamed(RouteName.localStudent);
                BlocProvider.of<StudentBloc>(context).add(StudentEventLoad());
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  void formSubmit() {
    _formKey.currentState?.save();
    showSnackInfoBar(context, 'Данные сохранены');
    PaysRepository().insertStudentPayments(
      PaymentsDB(null, int.parse(_payValue.text), _dateValue.text,
          widget._userData.id!),
    );
  }
}
