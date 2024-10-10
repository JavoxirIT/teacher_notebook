import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/widgets/form/validate/validate_phone.dart';
import 'package:assistant/widgets/form/validate/validete_form_fild.dart';
import 'package:assistant/widgets/form/validate/validete_form_text.dart';
import 'package:assistant/db/models/student_bd_models.dart';
import 'package:assistant/style/clear_button_style.dart';

class StudentUpdateForm extends StatefulWidget {
  const StudentUpdateForm({Key? key}) : super(key: key);

  @override
  _StudentUpdateFormState createState() => _StudentUpdateFormState();
}

class _StudentUpdateFormState extends State<StudentUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  late int? _studentID;

  final sDateFormate = "dd/MM/yyyy";

  final _studentName = TextEditingController();
  final _studentSurName = TextEditingController();
  final _studentSecondName = TextEditingController();
  final _studentBrithDay = TextEditingController();
  final _studentAddres = TextEditingController();
  final _studentPhone = TextEditingController();
  final _studentSchoolAndClassNumber = TextEditingController();
  final _studentDocumentNomer = TextEditingController();

  final _studentImg = TextEditingController();
  final _studentPayStatus = TextEditingController();
  final _studentParentId = TextEditingController();

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
    _studentImg.dispose();
    _studentPayStatus.dispose();
    _studentParentId.dispose();
    super.dispose();
  }

  late StudentDB _userData;

  @override
  Widget build(BuildContext context) {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    _userData = setting.arguments as StudentDB;
    _studentName.text = _userData.studentName;
    _studentSurName.text = _userData.studentSurName;
    _studentSecondName.text = _userData.studentSecondName;
    _studentBrithDay.text = _userData.studentBrithDay;
    _studentAddres.text = _userData.studentAddres;
    _studentPhone.text = _userData.studentPhone;
    _studentSchoolAndClassNumber.text = _userData.studentSchoolAndClassNumber;
    _studentDocumentNomer.text = _userData.studentDocumentNomer;
    _studentID = _userData.id;

    // _studentPayStatus.text = _userData.studentPayStatus;
    _studentParentId.text = _userData.studentParentsFio;
    // _studentImg.text = _userData.studentImg;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_userData.studentSecondName}  ${_userData.studentName}'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                // const FormImagePicker(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    validator: validate,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    validator: (value) =>
                        validatePhoneFormatter(value as String),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

                SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
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
                                _studentDocumentNomer.text)
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'С начало добавьте данные',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                backgroundColor: Colors.deepOrangeAccent,
                                duration: const Duration(seconds: 2),
                                width: 280.0, // Width of the SnackBar.
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical:
                                        12.0 // Inner padding for SnackBar content.
                                    ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            )
                          }
                      },
                      child: const Text(
                        "Изменить",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
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
  ) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Пожалуйста проверьте данные!",
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: [
                Text('имя: $studentName',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('фамилия:  $studentSurName',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('отчество: $studentSecondName',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('дата рож: $studentBrithDay',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('Метирка или паспорт: $studentDocumentNomer',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('адрес: $studentAddres',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('тел: $studentPhone',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('Номер школы и класс: $studentSchoolAndClassNumber',
                    style: Theme.of(context).textTheme.titleSmall),
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
                Navigator.of(context).pushNamed(
                  RouteName.localStudent,
                );
              },
              child: const Text("Да"),
            ),
          ],
        );
      },
    );
  }

  // UPDATE FUNCTION
  void formSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      // DBProvider.db.updateStudent(
      //   StudentDB(
      //     _studentID,
      //     _studentName.text,
      //     _studentSecondName.text,
      //     _studentSurName.text,
      //     _studentBrithDay.text,
      //     _studentAddres.text,
      //     _studentPhone.text,
      //     _studentSchoolAndClassNumber.text,
      //     _studentDocumentNomer.text,
      //   ),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные изменены')),
      );
    } else {
      debugPrint('Form is not valid');
    }
  }
}
