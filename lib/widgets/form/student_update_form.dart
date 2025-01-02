import 'dart:convert';
import 'dart:io';

import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/camera/camera_page.dart';
import 'package:TeamLead/widgets/form/validate/validate_phone.dart';
import 'package:TeamLead/widgets/form/validate/validete_form_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class StudentUpdateForm extends StatefulWidget {
  const StudentUpdateForm({super.key});

  @override
  State<StudentUpdateForm> createState() => _StudentUpdateFormState();
}

class _StudentUpdateFormState extends State<StudentUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? base64String;
  late int? _studentID;
  final noImage = "assets/images/no-image.png";
  final sDateFormate = "dd/MM/yyyy";

  final _studentName = TextEditingController();
  final _studentSurName = TextEditingController();
  final _studentSecondName = TextEditingController();
  final _studentBrithDay = TextEditingController();
  final _studentAddres = TextEditingController();
  final _studentPhone = TextEditingController();
  final _studentSchoolAndClassNumber = TextEditingController();
  final _studentDocumentNomer = TextEditingController();
  int _studentPayStatus = -1;
  final _studentParentFio = TextEditingController();
  final _studentParentPhone = TextEditingController();
  File? _studentImg;
  String? _pictureName;
  late StudentDB _userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Получаем аргументы только если они еще не были получены
    if (!_studentName.hasListeners) {
      RouteSettings setting = ModalRoute.of(context)!.settings;
      _userData = setting.arguments as StudentDB;
      _studentName.text = _userData.studentName;
      _studentSurName.text = _userData.studentSurName;
      _studentSecondName.text = _userData.studentSecondName;
      _studentBrithDay.text = _userData.studentBrithDay!;
      _studentAddres.text = _userData.studentAddres!;
      _studentPhone.text = _userData.studentPhone;
      _studentSchoolAndClassNumber.text = _userData.studentSchoolAndClassNumber!;
      _studentDocumentNomer.text = _userData.studentDocumentNomer!;
      _studentID = _userData.id;
      _studentParentFio.text = _userData.studentParentsFio!;
      _studentParentPhone.text = _userData.studentParentsPhone!;
      _studentPayStatus = _userData.studentPayStatus;
    }
  }

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
    _studentParentFio.dispose();
    _studentParentPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_userData.studentName} ${_userData.studentSecondName}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Image Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Фотография',
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(16),
                        ClipOval(
                          child: _studentImg != null
                              ? Image.file(
                                  _studentImg!,
                                  fit: BoxFit.cover,
                                  width: 120.0,
                                  height: 120.0,
                                )
                              : Image.asset(
                                  noImage,
                                  fit: BoxFit.cover,
                                  width: 120.0,
                                  height: 120.0,
                                ),
                        ),
                        const Gap(16),
                        OutlinedButton.icon(
                          onPressed: () => dataCamera(),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Открыть камеру"),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),

                // Personal Information Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Личная информация',
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentName,
                          label: 'Имя',
                          icon: Icons.person_outline,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentSurName,
                          label: 'Фамилия',
                          icon: Icons.person,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentSecondName,
                          label: 'Отчество',
                          icon: Icons.person,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentBrithDay,
                          label: 'Дата рождения',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _studentBrithDay.text =
                                    "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                              });
                            }
                          },
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),

                // Contact Information Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Контактная информация',
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentPhone,
                          label: 'Телефон студента',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) => value != null ? validatePhoneFormatter(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentAddres,
                          label: 'Адрес',
                          icon: Icons.location_on,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentParentFio,
                          label: 'ФИО родителя',
                          icon: Icons.person_2_outlined,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentParentPhone,
                          label: 'Телефон родителя',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) => value != null ? validatePhoneFormatter(value) : "Заполните поле",
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(16),

                // Education Information Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Информация об обучении',
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentSchoolAndClassNumber,
                          label: 'Школа и класс',
                          icon: Icons.school,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        _buildTextField(
                          controller: _studentDocumentNomer,
                          label: 'Номер документа',
                          icon: Icons.document_scanner,
                          validator: (value) => value != null ? validateText(value) : "Заполните поле",
                        ),
                        const Gap(16),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Форма обучения',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.payment),
                          ),
                          value: _studentPayStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text("Платно"),
                            ),
                            DropdownMenuItem(
                              value: 0,
                              child: Text("Бесплатно"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _studentPayStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      formSubmit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: colorBlue,
                  ),
                  child: const Text("Сохранить изменения", style: TextStyle(fontSize: 16, color: colorWhite)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
    );
  }

  Future<void> formSubmit() async {
    try {
      final result = await StudentRepository.db.updateStudent(
        StudentDB(
          id: _studentID,
          studentName: _studentName.text.trim(),
          studentSecondName: _studentSecondName.text.trim(),
          studentSurName: _studentSurName.text.trim(),
          studentBrithDay: _studentBrithDay.text.trim(),
          studentPhone: _studentPhone.text.trim(),
          studentAddres: _studentAddres.text.trim(),
          studentDocumentNomer: _studentDocumentNomer.text.trim(),
          studentParentsFio: _studentParentFio.text.trim(),
          studentParentsPhone: _studentParentPhone.text.trim(),
          studentSchoolAndClassNumber: _studentSchoolAndClassNumber.text.trim(),
          studentImg: base64String ?? _userData.studentImg,
          studentPayStatus: _studentPayStatus,
        ),
      );
      
      if (!mounted) return;
      
      if (result == DatabaseResult.success) {
        Navigator.of(context).pushReplacementNamed(RouteName.localStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные успешно обновлены')),
        );
      }
    } on DatabaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка базы данных: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Произошла ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    Uint8List bytes = await _studentImg!.readAsBytes();

    // base64 encode the bytes
    String b64Str = base64.encode(bytes);
    setState(() {
      base64String = b64Str;
      // print('base64String---->: ${base64String}');
    });
  }
}
