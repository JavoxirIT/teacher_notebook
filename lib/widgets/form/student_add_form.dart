import 'dart:convert';
import 'dart:io';

import 'package:TeamLead/bloc/student_bloc/student_bloc.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/widgets/camera/camera_page.dart';
import 'package:TeamLead/widgets/form/validate/validate_phone.dart';
import 'package:TeamLead/widgets/form/validate/validete_form_fild.dart';
import 'package:TeamLead/widgets/form/validate/validete_form_text.dart';
import 'package:TeamLead/widgets/show_snak_bar.dart';
import 'package:TeamLead/widgets/table_row.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAddForm extends StatefulWidget {
  const StudentAddForm(this.group, {super.key});

  final List<GroupDB> group;

  @override
  State<StudentAddForm> createState() => _StudentAddFormState();
}

class _StudentAddFormState extends State<StudentAddForm> {
  String base64String = '';
  final noImage = "assets/images/no-image.png";
  final sDateFormate = "dd/MM/yyyy";
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  File? _studentImg;
  String? _pictureName;
  final _studentName = TextEditingController();
  final _studentSurName = TextEditingController();
  final _studentSecondName = TextEditingController();
  final _studentBrithDay = TextEditingController();
  final _studentAddres = TextEditingController();
  final _studentPhone = TextEditingController();
  final _studentSchoolAndClassNumber = TextEditingController();
  final _studentDocumentNomer = TextEditingController();
  final _studentParentsFio = TextEditingController();
  final _studentParentsPhone = TextEditingController();
  int _studentPayStatus = 1;

  @override
  void dispose() {
    _studentName.dispose();
    _studentSurName.dispose();
    _studentSecondName.dispose();
    _studentBrithDay.dispose();
    _studentAddres.dispose();
    _studentPhone.dispose();
    _studentSchoolAndClassNumber.dispose();
    _studentDocumentNomer.dispose();
    _studentParentsFio.dispose();
    _studentParentsPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            Column(
                mainAxisSize: MainAxisSize.min,
                children: _studentImg != null
                    ? [
                        ClipOval(
                          child: Image.file(
                            _studentImg!,
                            fit: BoxFit.cover,
                            // width: MediaQuery.of(context).size.width),
                            width: 180.0,
                            height: 180.0,
                          ),
                        )
                      ]
                    : [
                        ClipOval(
                          child: Image.asset(
                            noImage,
                            fit: BoxFit.cover,
                            width: 180.0,
                            height: 180.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text("Нет изображения",
                            style: Theme.of(context).textTheme.titleLarge)
                      ]),
            OutlinedButton(
              onPressed: () {
                dataCamera();
              },
              child: const Text("Открыть камеру"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentName,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentName.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                    ),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Имя',
                ),
                validator: (value) => valideteText(value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextFormField(
                controller: _studentSurName,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentSurName.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Фамилия',
                ),
                validator: (value) => valideteText(value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentSecondName,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentSecondName.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Отчество',
                ),
                validator: (value) => valideteText(value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentBrithDay,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _studentBrithDay.clear();
                      },
                      child: const Icon(Icons.delete_outline),
                    ),
                    labelText: "Число, Месяц, Год рождения",
                    helperText: "01.01.1999"),
                // onTap: () async {
                //   DateTime? date = DateTime(1900);
                //   FocusScope.of(context).requestFocus(FocusNode());

                //   date = await showDatePicker(
                //     context: context,
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime(1900),
                //     lastDate: DateTime(2100),
                //   );

                //   dateCtl.text = date.toString();
                // },
                // onTap: () async {
                //   await showDatePicker(
                //     context: context,
                //     // locale: const Locale('uz', 'UZ'),
                //     initialDate: DateTime.now(), //get today's date
                //     firstDate: DateTime(
                //         1970), //DateTime.now() - not to allow to choose before today.
                //     lastDate: DateTime(2101),
                //     helpText: "Выберите дату",
                //     cancelText: "Закрыть",
                //     confirmText: "Принять",
                //     fieldHintText: sDateFormate,
                //   ).then(
                //     (value) => {
                //       setState(() {
                //         _studentBrithDay.text = value.toString();
                //       })
                //     },
                //   );
                // },
                validator: validate,
                keyboardType: TextInputType.datetime,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentDocumentNomer,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _studentDocumentNomer.clear();
                      },
                      child: const Icon(Icons.delete_outline),
                    ),
                    border: const UnderlineInputBorder(),
                    labelText: 'Серия и номер меторки или паспорта',
                    helperText: "AB 9632325"),
                validator: validate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentAddres,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentAddres.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Адрес проживания',
                ),
                validator: validate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentPhone,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentPhone.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Контактный номер',
                  helperText: "997770101",
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                      allow: true)
                ],
                maxLength: 9,
                validator: (value) => validatePhoneFormatter(value as String),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentSchoolAndClassNumber,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentSchoolAndClassNumber.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Номер школы и класс',
                  helperText: "№ 00 -  8B класс",
                ),
                // keyboardType: TextInputType.multiline,
                validator: validate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentParentsFio,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentParentsFio.clear();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                    ),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Фамилия и Имя Радителя',
                ),
                validator: (value) => valideteText(value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _studentParentsPhone,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _studentParentsPhone.clear();
                    },
                    child: const Icon(Icons.delete_outline),
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: 'Контактный номер радителя',
                  helperText: "997770101",
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                      allow: true)
                ],
                maxLength: 9,
                validator: (value) => validatePhoneFormatter(value as String),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text('Форма обучения'),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Платно")),
                  DropdownMenuItem(value: 0, child: Text("Безплатно")),
                ],
                onChanged: (value) {
                  setState(() {
                    _studentPayStatus = value!;
                  });
                },
                validator: (val) =>
                    val == null ? "Выберите форму обучения" : null,
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: OutlinedButton(
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        _showDialog(
                          context,
                          _studentName.text,
                          _studentSurName.text,
                          _studentSecondName.text,
                          _studentBrithDay.text,
                          _studentAddres.text,
                          _studentPhone.text,
                          _studentSchoolAndClassNumber.text,
                          _studentDocumentNomer.text,
                          _studentParentsFio.text,
                          _studentParentsPhone.text,
                          _studentPayStatus,
                        )
                      }
                    else
                      {showSnackInfoBar(context, 'Сначала добавьте данные')}
                  },
                  child: const Text(
                    "Добавить",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dataCamera() async {
    final camera = await availableCameras().then((value) {
      return value;
    });
    Route route = MaterialPageRoute(
      builder: (_) => CameraPage(cameras: camera),
    );
    final result = await Navigator.push(context, route);

    setState(() {
      if (result != null) {
        _studentImg = File(result.path);
        _pictureName = result.name;
      }
    });

    imagetoBase64();
  }

  imagetoBase64() async {
    // Read bytes from the file object
    Uint8List _bytes = await _studentImg!.readAsBytes();

    // base64 encode the bytes
    String _base64String = base64.encode(_bytes);
    setState(() {
      base64String = _base64String;
      // print('base64String---->: ${base64String}');
    });
  }

  Future<void> _showDialog(
      BuildContext context,
      studentName,
      studentSurName,
      studentSecondName,
      studentBrithDay,
      studentAddres,
      studentPhone,
      studentSchoolAndClassNumber,
      studentDocumentNomer,
      studentParentFio,
      studentParentPhone,
      studentPayStatus) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String status = studentPayStatus == 1 ? "Платно" : "Безплатно";

        return AlertDialog(
          title: const Text(
            "Пожалуйста проверте данные!",
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Table(
              // shrinkWrap: true,
              children: <TableRow>[
                tableRow(context, "Имя", studentName),
                tableRow(context, "Фамилия", studentSurName),
                tableRow(context, "Отчество", studentSecondName),
                tableRow(context, "День рождения", studentBrithDay),
                tableRow(context, "Метирка или паспорт", studentDocumentNomer),
                tableRow(context, "Адрес", studentAddres),
                tableRow(context, "Тел", studentPhone),
                tableRow(context, "Номер школы и класс",
                    studentSchoolAndClassNumber),
                tableRow(context, "Радитель", studentParentFio),
                tableRow(context, "Контакт радителя", studentParentPhone),
                tableRow(context, "Форма обученя", status),
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
                BlocProvider.of<StudentBloc>(context).add(StudentEventLoad());
              },
              child: const Text("Да"),
            ),
          ],
        );
      },
    );
  }

  void formSubmit() {
    _formKey.currentState?.save();
    showSnackInfoBar(context, 'Данные сохранены');
    StudentRepository.db.insertStudent(
      StudentDB(
          null,
          _studentName.text,
          _studentSecondName.text,
          _studentSurName.text,
          _studentBrithDay.text,
          _studentAddres.text,
          _studentPhone.text,
          _studentSchoolAndClassNumber.text,
          _studentDocumentNomer.text,
          base64String,
          _studentPayStatus,
          _studentParentsFio.text,
          _studentParentsPhone.text,
          0,
          0),
    );
  }
}
