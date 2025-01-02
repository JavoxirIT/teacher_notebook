import 'package:TeamLead/bloc/student_bloc/student_bloc.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/form/validate/validate_phone.dart';
import 'package:TeamLead/widgets/form/validate/validete_form_text.dart';
import 'package:TeamLead/widgets/show_cupertino_modal_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class StudentAddForm extends StatefulWidget {
  const StudentAddForm(List<GroupDB> group, {super.key});

  @override
  State<StudentAddForm> createState() => _StudentAddFormState();
}

class _StudentAddFormState extends State<StudentAddForm> {
  final _formKey = GlobalKey<FormState>();
  String _studentBrithDay = "";
  final noImage = "assets/images/no-image.png";

  final _studentName = TextEditingController();
  final _studentSurName = TextEditingController();
  final _studentSecondName = TextEditingController();
  final _studentPhone = TextEditingController();
  int _studentPayStatus = 1;

  @override
  void dispose() {
    _studentName.dispose();
    _studentSurName.dispose();
    _studentSecondName.dispose();
    _studentPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                            validator: (value) => validateText(value!),
                          ),
                          const Gap(16),
                          _buildTextField(
                            controller: _studentSurName,
                            label: 'Фамилия',
                            icon: Icons.person,
                            validator: (value) => validateText(value!),
                          ),
                          const Gap(16),
                          _buildTextField(
                            controller: _studentSecondName,
                            label: 'Отчество',
                            icon: Icons.person,
                            validator: (value) => validateText(value!),
                          ),
                          const Gap(16),
                          // Date Picker
                          InkWell(
                            onTap: () => showDatePickerDialog(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Дата рождения',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _studentBrithDay.isEmpty
                                    ? 'Выберите дату'
                                    : _studentBrithDay,
                              ),
                            ),
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
                              FilteringTextInputFormatter(
                                  RegExp(r'^[()\d -]{1,15}$'),
                                  allow: true)
                            ],
                            maxLength: 9,
                            validator: (value) =>
                                validatePhoneFormatter(value as String),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Payment Status Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Форма обучения',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Gap(16),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Выберите форму обучения',
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
                        if (_studentBrithDay.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Пожалуйста, выберите дату рождения'),
                            ),
                          );
                          return;
                        }
                        
                        final scaffoldContext = ScaffoldMessenger.of(context);
                        final navigationContext = Navigator.of(context);
                        final blocContext =
                            BlocProvider.of<StudentBloc>(context);

                        _saveData(
                          scaffoldContext: scaffoldContext,
                          navigationContext: navigationContext,
                          blocContext: blocContext,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: colorBlue,
                    ),
                    child: const Text(
                      'Добавить студента',
                      style: TextStyle(fontSize: 16,color: colorWhite),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: GestureDetector(
          onTap: () => controller.clear(),
          child: const Icon(Icons.clear),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      validator: validator,
    );
  }

  void showDatePickerDialog(BuildContext context) {
    showCupModalPopup(
      CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            _studentBrithDay = DateFormat('dd.MM.yyyy').format(newDate);
          });
        },
      ),
      context,
      500,
    );
  }

  Future<void> _saveData({
    required ScaffoldMessengerState scaffoldContext,
    required NavigatorState navigationContext,
    required StudentBloc blocContext,
  }) async {
    _formKey.currentState?.save();
    try {
      final result = await StudentRepository.db.insertStudent(
        StudentDB(
          studentName: _studentName.text,
          studentSecondName: _studentSecondName.text,
          studentSurName: _studentSurName.text,
          studentPhone: _studentPhone.text,
          studentPayStatus: _studentPayStatus,
          studentBrithDay: _studentBrithDay,
        ),
      );

      if (!mounted) return;

      if (result == DatabaseResult.success) {
        scaffoldContext.showSnackBar(
          const SnackBar(content: Text('Студент успешно добавлен')),
        );
        navigationContext.pop();
        blocContext.add(StudentEventLoad());
      }
    } on DatabaseException catch (e) {
      if (!mounted) return;
      scaffoldContext.showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      scaffoldContext.showSnackBar(
        const SnackBar(content: Text('Произошла неизвестная ошибка')),
      );
    }
  }
}
