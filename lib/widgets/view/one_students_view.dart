import 'dart:convert';

import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gap/gap.dart';

class OneStudentsView extends StatefulWidget {
  const OneStudentsView({super.key});

  @override
  State<OneStudentsView> createState() => _OneStudentsViewState();
}

class _OneStudentsViewState extends State<OneStudentsView> {
  late StudentDB _userData;

  // Uint8List? _studentImg;
  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    _userData = setting.arguments as StudentDB;
    setState(() {});
    super.didChangeDependencies();
  }

  // void _callNumber() {
  //   FlutterPhoneDirectCaller.callNumber(_userData.studentPhone);
  // }

  dataPayStatus() {
    if (_userData.studentPayStatus == 1) {
      return "Платно";
    }

    return "Бесплатно";
  }

  @override
  Widget build(BuildContext context) {
    final nameTextStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: colorWhite, fontSize: 18.0);

    const buttonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(colorWhite),
      foregroundColor: WidgetStatePropertyAll(colorBlue),
      side: WidgetStatePropertyAll(BorderSide.none),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
      ),
    );

    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlue,
        actions: [
          // OutlinedButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(
          //       RouteName.payAdnPayAddView,
          //       arguments: _userData,
          //     );
          //   },
          //   style: buttonStyle,
          //   child: const Text("Добавить оплату"),
          // ),
          // const Gap(10.0),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteName.localSudentUpdate,
                arguments: _userData,
              );
            },
            style: buttonStyle,
            child: const Text("Редактировать"),
          ),
          const Gap(10.0),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: colorBlue,
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: colorWhite,
                    radius: 90,
                    child: ClipOval(
                      child: _userData.studentImg != ""
                          ? Image.memory(
                              const Base64Decoder()
                                  .convert(_userData.studentImg!),
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            )
                          : Icon(
                              Icons.no_accounts,
                              size: 150,
                              color: colorBlue,
                            ),
                    ),
                  ),
                ),
                const Gap(10.0),
                Text(
                  'Имя:  ${_userData.studentName}',
                  style: nameTextStyle,
                ),
                Text(
                  'Фамилия:  ${_userData.studentSurName}',
                  style: nameTextStyle,
                ),
                Text(
                  'Отчество:  ${_userData.studentSecondName}',
                  style: nameTextStyle,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  TableCell(
                    child: Text('Дата рождения:',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentBrithDay,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Номер документа CE',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentDocumentNomer,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Адрес прожтвания',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentAddres,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Образование или школа',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentSchoolAndClassNumber,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Контактный номер студента',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentPhone,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Радитель',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentParentsFio,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Контактеый номер радитель',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      _userData.studentParentsPhone,
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
                TableRow(children: [
                  TableCell(
                    child: Text('Форма обучения',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  TableCell(
                    child: Text(
                      dataPayStatus(),
                      style: bodyLarge,
                      textAlign: TextAlign.end,
                    ),
                  )
                ]),
              ],
            ),
          ),
          Gap(10.0),
          Center(
            child: Text("Все оплаты"),
          ),
          Gap(10.0),
          // Expanded(child: OneStudentPaymentsData(studentId: _userData.id!))
        ],
      ),
    );
  }
}
