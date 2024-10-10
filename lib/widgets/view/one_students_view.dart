import 'dart:convert';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/theme/style_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:assistant/db/models/student_bd_models.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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

  void _callNumber() {
    FlutterPhoneDirectCaller.callNumber(_userData.studentPhone);
  }

  dataPayStatus() {
    if (_userData.studentPayStatus == 1) {
      return "Платно";
    }

    return "Бесплатно";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_userData.studentName}  ${_userData.studentSurName}'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: iconGreenColor,
                    radius: 90,
                    child: ClipOval(
                      child: _userData.studentImg != "" ? Image.memory(
                        const Base64Decoder().convert(_userData.studentImg!),
                        fit: BoxFit.cover,
                        width: 170,
                        height: 170,
                      ) : null,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Имя:  ${_userData.studentName}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.solidUser),
                ),
                ListTile(
                  title: Text('Фамилия:  ${_userData.studentSurName}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.solidUser),
                ),
                ListTile(
                  title: Text('Отчество:  ${_userData.studentSecondName}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.solidUser),
                ),
                ListTile(
                  title: Text('Дата рождения:  ${_userData.studentBrithDay}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.calendar),
                ),
                ListTile(
                  title: Text('Адресс:  ${_userData.studentAddres}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.addressCard),
                ),
                ListTile(
                  title: Text(
                      'Школа и класс:  ${_userData.studentSchoolAndClassNumber}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.addressCard),
                ),
                ListTile(
                  title: Text('С/П или С/М:  ${_userData.studentDocumentNomer}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.addressCard),
                ),
                ListTile(
                  splashColor: colorGreen,
                  title: Text('Тел:  ${_userData.studentPhone}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(
                    FontAwesomeIcons.phone,
                  ),
                  onTap: () {
                    _callNumber();
                  },
                ),
                ListTile(
                  title: Text('Ф.И радителя: ${_userData.studentParentsFio}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(FontAwesomeIcons.addressCard),
                ),
                ListTile(
                  splashColor: colorGreen,
                  title: Text(
                      'Тел. родителя:  ${_userData.studentParentsPhone}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(
                    FontAwesomeIcons.phone,
                  ),
                  onTap: () {
                    _callNumber();
                  },
                ),
                ListTile(
                  title: Text('Обучение:  ${dataPayStatus()}',
                      style: Theme.of(context).textTheme.bodyMedium),
                  leading: const Icon(
                    FontAwesomeIcons.cashRegister,
                  ),
                ),
                // ListTile(
                //   title: Text('Группа:  ${_userData.studentGroupName}',
                //       style: Theme.of(context).textTheme.bodyMedium),
                //   leading: const Icon(
                //     FontAwesomeIcons.cashRegister,
                //   ),
                // ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  buttonPadding: const EdgeInsets.all(20.0),
                  buttonMinWidth: 250.0,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Route route = MaterialPageRoute(
                        //     builder: (context) =>
                        //         PaymentsView(student: _userData));
                        // Navigator.push(context, route);
                        Navigator.of(context).pushNamed(
                          RouteName.payAdnPayAddView,
                          arguments: _userData,
                        );
                      },
                      child: const Text("Добавить оплату"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RouteName.localSudentUpdate,
                          arguments: _userData,
                        );
                      },
                      // style: outlineButtonStyleDanger,
                      child: const Text("Редактировать"),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
