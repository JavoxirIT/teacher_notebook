import 'dart:io';
import 'package:TeamLead/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:TeamLead/bloc/student_in_a_group_bloc/student_in_a_group_bloc.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:TeamLead/services/notification_service.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/form/attendance_history.dart';
import 'package:TeamLead/widgets/view/view_widgets/student_add_to_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:TeamLead/db/payments_repository.dart';
import 'package:TeamLead/db/models/payments_db_models.dart';
import 'package:TeamLead/widgets/view/group_payments_history.dart';
import 'package:TeamLead/widgets/view/attendance_table_view.dart';
import 'package:TeamLead/widgets/common/gradient_background.dart';

class OneGroupList extends StatefulWidget {
  final GroupDB group;

  const OneGroupList({
    super.key,
    required this.group,
  });

  @override
  State<OneGroupList> createState() => _OneGroupListState();
}

class _OneGroupListState extends State<OneGroupList> {
  late final PaysRepository _paymentsRepository;
  bool _isMarkingAttendance = false;
  bool _isTableView = false;
  final Map<int, bool> _selectedStudents = {};
  late final NotificationService _notificationService;
  String _selectedStatus = 'present';
  late final TextEditingController _commentController;
  late final TextEditingController _paymentAmountController;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru');
    // Инициализируем контроллеры и сервисы
    _paymentsRepository = PaysRepository.db;
    _notificationService = NotificationService();
    _commentController = TextEditingController();
    _paymentAmountController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadData();
  }

  void _loadData() {
    // Загружаем список студентов
    if (mounted) {
      context
          .read<StudentInAGroupBloc>()
          .add(LoadStudentsEvent(widget.group.id!));

      // Загружаем данные посещаемости на выбранную дату
      context.read<AttendanceBloc>().add(LoadGroupAttendance(
            widget.group.id!,
            DateFormat('yyyy-MM-dd').format(_selectedDate),
          ));

      // Загружаем статусы оплаты через bloc
      context.read<StudentInAGroupBloc>().add(
            UpdatePaymentStatusesEvent(widget.group.id!, _selectedMonth),
          );
    }
  }

  void _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      // Обновляем статусы оплаты через bloc
      context.read<StudentInAGroupBloc>().add(
            UpdatePaymentStatusesEvent(widget.group.id!, _selectedMonth),
          );
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Загружаем данные посещаемости для выбранной даты
      context.read<AttendanceBloc>().add(LoadGroupAttendance(
            widget.group.id!,
            DateFormat('yyyy-MM-dd').format(picked),
          ));
    }
  }

  void _toggleAttendanceMode() {
    setState(() {
      _isMarkingAttendance = !_isMarkingAttendance;
      if (!_isMarkingAttendance) {
        _selectedStudents.clear();
      }
    });
  }

  void _toggleStudentSelection(int studentId) {
    setState(() {
      _selectedStudents[studentId] = !(_selectedStudents[studentId] ?? false);
    });
  }

  Future<void> _markAttendance() async {
    if (_selectedStudents.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одного студента')),
      );
      return;
    }

    final timestamp = _selectedDate.millisecondsSinceEpoch ~/ 1000;
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Подтверждение'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Отметить ${_selectedStudents.values.where((v) => v).length} студентов как:',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'present',
                        label: Text('Присутствует'),
                        icon: Icon(Icons.check_circle_outline),
                      ),
                      ButtonSegment(
                        value: 'late',
                        label: Text('Опоздал'),
                        icon: Icon(Icons.access_time),
                      ),
                      ButtonSegment(
                        value: 'absent',
                        label: Text('Отсутствует'),
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                    selected: {_selectedStatus},
                    onSelectionChanged: (Set<String> newSelection) {
                      setDialogState(() {
                        _selectedStatus = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Комментарий (необязательно)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Подтвердить'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm != true || !mounted) return;

    // Отмечаем посещаемость для каждого выбранного студента
    for (var entry in _selectedStudents.entries) {
      if (entry.value) {
        final attendance = AttendanceDB(
          studentId: entry.key,
          groupId: widget.group.id!,
          date: date,
          status: _selectedStatus,
          comment: _commentController.text,
          timestampSeconds: timestamp,
          isNotified: false,
        );

        if (!mounted) return;
        context.read<AttendanceBloc>().add(MarkAttendance(attendance));

        try {
          final state = context.read<StudentInAGroupBloc>().state;
          if (state is StudentInAGroupLoadState) {
            final student =
                state.data.firstWhere((s) => s.studentId == entry.key);

            await _notificationService.sendAttendanceNotification(
              phoneNumber: student.studentParentsPhone ?? '',
              studentName: '${student.studentName} ${student.studentSurName}',
              status: _selectedStatus,
              date: date,
            );
          }
        } catch (e) {
          debugPrint('Ошибка отправки уведомления: $e');
        }
      }
    }

    setState(() {
      _selectedStudents.clear();
      _isMarkingAttendance = false;
      _commentController.clear();
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Посещаемость успешно отмечена')),
    );
  }

  Future<Widget> _getPaymentStatusTag(StudentInAGroupModels student) async {
    debugPrint('StudentInAGroupModels: $student');

    if (student.studentPayStatus != 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: colorGrey200.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: const Text(
          'Бесплатно',
          style: TextStyle(color: Colors.black87, fontSize: 10),
        ),
      );
    }

    final monthKey = '${_selectedMonth.month}-${_selectedMonth.year}';
    // final state = context.read<StudentInAGroupBloc>().state;

    if (student.studentPayStatus == 1) {
      final hasPaid = await _paymentsRepository.hasPaymentForCurrentMonth(
          student.studentId, _selectedMonth.month, _selectedMonth.year);
      // debugPrint('HAS PAID: $hasPaid');

      if (hasPaid == PaysRepositoryStatus.success) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colorBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Оплачено',
            style: TextStyle(color: colorBlue, fontSize: 10),
          ),
        );
      }

      final now = DateTime.now();
      final selectedMonthDate =
          DateTime(_selectedMonth.year, _selectedMonth.month);
      final currentMonthDate = DateTime(now.year, now.month);
      // debugPrint('CURRENT MOTH DATE: $currentMonthDate');
      // debugPrint('SELECTED MOTH DATE: $selectedMonthDate');

      if (!selectedMonthDate.isAfter(currentMonthDate)) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red[200]!.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[700]!, width: 1),
          ),
          child: Text(
            'Не оплачено',
            style: TextStyle(color: Colors.red[700], fontSize: 10),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange[200]!.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Ожидается',
          style: TextStyle(color: Colors.orange[700], fontSize: 10),
        ),
      );
    }

    return const SizedBox(); // Возвращаем пустой виджет если состояние не загружено
  }

  Widget _getAttendanceStatusTag(String status) {
    final (String label, Color color) = switch (status) {
      'present' => ('Присутствует', Colors.green),
      'late' => ('Опоздал', Colors.orange),
      'absent' => ('Отсутствует', Colors.red),
      _ => ('Не отмечен', Colors.grey)
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStudentAvatar(StudentInAGroupModels student) {
    Widget defaultAvatar = CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Text(
        student.studentName[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (student.studentImg == null || student.studentImg!.isEmpty) {
      return defaultAvatar;
    }

    try {
      return CircleAvatar(
        backgroundColor: Colors.blue[100],
        backgroundImage: FileImage(File(student.studentImg!)),
        onBackgroundImageError: (_, __) {},
        child: Text(
          student.studentName[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } catch (e) {
      return defaultAvatar;
    }
  }

  void _showPaymentDialog() {
    // Создаем локальную копию выбранных студентов для диалога
    final Map<int, bool> dialogSelectedStudents = Map.from(_selectedStudents);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: const Text('Отметка оплаты'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _paymentAmountController,
                          placeholder: 'Сумма оплаты',
                          prefix: const Text('₽'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        child: const Icon(CupertinoIcons.calendar),
                        onPressed: () async {
                          final date = await showCupertinoModalPopup(
                            context: context,
                            builder: (context) => Container(
                              height: 250,
                              color: CupertinoColors.white,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: _selectedDate,
                                minimumDate: DateTime(2020),
                                maximumDate:
                                    DateTime.now().add(const Duration(days: 7)),
                                onDateTimeChanged: (value) {
                                  setState(() {
                                    _selectedDate = value;
                                  });
                                },
                              ),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Text(
                  'Дата: ${DateFormat('dd MMMM yyyy', 'ru').format(_selectedDate)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(),
                const Text(
                  'Выберите учеников:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                BlocBuilder<StudentInAGroupBloc, StudentInAGroupState>(
                  builder: (context, state) {
                    if (state is StudentInAGroupLoadState) {
                      return Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CupertinoButton(
                                child: const Text('Выбрать всех'),
                                onPressed: () {
                                  setState(() {
                                    for (var student in state.data) {
                                      dialogSelectedStudents[
                                          student.studentId] = true;
                                    }
                                  });
                                },
                              ),
                              const Divider(),
                              ...state.data.map((student) => CupertinoButton(
                                    child: Text(
                                        '${student.studentName} ${student.studentSurName}'),
                                    onPressed: () {
                                      setState(() {
                                        dialogSelectedStudents[
                                                student.studentId] =
                                            !dialogSelectedStudents[
                                                    student.studentId]! ??
                                                false;
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                      );
                    }
                    return const CupertinoActivityIndicator();
                  },
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Отмена'),
              onPressed: () {
                _paymentAmountController.clear();
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Отметить оплату'),
              onPressed: () async {
                if (_paymentAmountController.text.isEmpty) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Ошибка'),
                      content: const Text('Введите сумму оплаты'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final amount = int.tryParse(_paymentAmountController.text);
                if (amount == null || amount <= 0) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Ошибка'),
                      content: const Text('Введите корректную сумму'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final selectedCount =
                    dialogSelectedStudents.values.where((v) => v).length;
                if (selectedCount == 0) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Ошибка'),
                      content: const Text('Выберите хотя бы одного ученика'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // Сохраняем оплату для каждого выбранного студента
                for (var entry in dialogSelectedStudents.entries) {
                  if (entry.value) {
                    final payment = PaymentsDB(
                      payments: amount,
                      studentId: entry.key,
                      day: _selectedDate.day.toString(),
                      month: _selectedDate.month.toString(),
                      year: _selectedDate.year.toString(),
                      timestampSeconds:
                          _selectedDate.millisecondsSinceEpoch ~/ 1000,
                      forWhichGroupId: widget.group.id!,
                    );

                    final result =
                        await PaysRepository.db.insertStudentPayments(payment);
                    if (result != "success") {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Ошибка'),
                          content: const Text('Ошибка при сохранении оплаты'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                  }
                }

                Navigator.pop(context);
                _paymentAmountController.clear();

                // Обновляем статусы оплаты через bloc
                context.read<StudentInAGroupBloc>().add(
                      RefreshPaymentStatusesEvent(
                          widget.group.id!, _selectedMonth),
                    );

                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Успешно'),
                    content: Text(
                        'Оплата успешно отмечена для $selectedCount учеников'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListItem(StudentInAGroupModels student, int index) {
    final isSelected = _selectedStudents[student.studentId] ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Colors.blue.withValues(alpha: .05) : Colors.white,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (_isMarkingAttendance) {
              setState(() {
                _selectedStudents[student.studentId] = !isSelected;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Colors.blue.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: _buildStudentAvatar(student),
                        ),
                        if (_isMarkingAttendance)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                isSelected
                                    ? Icons.check
                                    : Icons.check_box_outline_blank,
                                size: 12,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${student.studentName} ${student.studentSurName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '№${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                student.studentPhone ?? 'Нет телефона',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, state) {
                              if (state is AttendanceLoaded) {
                                final attendance = state.attendanceRecords
                                    .where(
                                        (a) => a.studentId == student.studentId)
                                    .firstOrNull;
                                return _getAttendanceStatusTag(
                                    attendance?.status ?? 'none');
                              }
                              return const SizedBox();
                            },
                          ),
                          const SizedBox(width: 8),
                          FutureBuilder<Widget>(
                            future: _getPaymentStatusTag(student),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!;
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (!_isMarkingAttendance)
                      CupertinoButton(
                        child: const Icon(CupertinoIcons.ellipsis),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  child: const Text('Удалить студента'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoAlertDialog(
                                        title: const Text('Подтверждение'),
                                        content: Text(
                                            'Вы уверены, что хотите удалить студента ${student.studentName}?'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('Отмена'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('Удалить'),
                                            onPressed: () {
                                              context
                                                  .read<StudentInAGroupBloc>()
                                                  .add(
                                                      StudentInAGroupDeleteEvent(
                                                    id: widget.group.id!,
                                                    studentId:
                                                        student.studentId,
                                                  ));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Отмена'),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentInAGroupBloc, StudentInAGroupState>(
      builder: (context, state) {
        if (state is StudentInAGroupLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is StudentInAGroupLoadState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(widget.group.groupName),
              actions: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.money_dollar),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            child: const Text('Выбрать месяц'),
                            onPressed: () {
                              Navigator.pop(context);
                              _selectMonth();
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text('История оплат'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => GroupPaymentsHistory(
                                    groupId: widget.group.id!,
                                    groupName: widget.group.groupName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                      ),
                    );
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    _isTableView
                        ? CupertinoIcons.list_bullet
                        : CupertinoIcons.table,
                  ),
                  onPressed: () {
                    setState(() {
                      _isTableView = !_isTableView;
                    });
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    _isMarkingAttendance
                        ? CupertinoIcons.xmark
                        : CupertinoIcons.checkmark_alt,
                  ),
                  onPressed: _toggleAttendanceMode,
                ),
                if (_isMarkingAttendance)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.checkmark_circle),
                    onPressed: _markAttendance,
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.person_add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            StudentAddToGroup(id: widget.group.id!),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.calendar),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    DateFormat('dd MMMM yyyy', 'ru')
                                        .format(_selectedDate),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(CupertinoIcons.ellipsis),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child:
                                                const Text('Отметить оплату'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _showPaymentDialog();
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('Выбрать дату'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _selectDate(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child:
                                                const Text('История посещений'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AttendanceHistoryScreen(
                                                    groupId: widget.group.id!,
                                                    groupName:
                                                        widget.group.groupName,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Отмена'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (_isMarkingAttendance) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text('Выбрано студентов: '),
                                  Text(
                                    '${_selectedStudents.values.where((v) => v).length}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  CupertinoButton.filled(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: const Text('Отметить'),
                                    onPressed: _markAttendance,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isTableView
                        ? BlocBuilder<AttendanceBloc, AttendanceState>(
                            builder: (context, attendanceState) {
                              if (attendanceState is MonthlyAttendanceLoaded) {
                                return AttendanceTableView(
                                  students: state.data,
                                  attendanceRecords:
                                      attendanceState.attendanceRecords,
                                  selectedMonth: _selectedMonth,
                                );
                              }
                              if (attendanceState is AttendanceError) {
                                return Center(
                                  child: Text(
                                      'Ошибка: ${attendanceState.message}'),
                                );
                              }
                              if (attendanceState is! MonthlyAttendanceLoaded) {
                                context.read<AttendanceBloc>().add(
                                      LoadMonthlyAttendance(
                                          widget.group.id!, _selectedMonth),
                                    );
                              }
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              final student = state.data[index];
                              return _buildStudentListItem(student, index);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is StudentInAGroupErrorState) {
          return Center(
            child: Text(
              'Ошибка: ${state.exception}',
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          );
        }
        if (state is StudentInAGroupNotDataState) {
          return const Center(
            child: Text(
              'В группе нет студентов',
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.inactiveGray,
              ),
            ),
          );
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    // Очищаем все ресурсы
    _paymentAmountController.dispose();
    _commentController.dispose();
    _selectedStudents.clear();
    super.dispose();
  }
}
