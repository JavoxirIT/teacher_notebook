import 'package:TeamLead/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:TeamLead/services/notification_service.dart';
import 'package:TeamLead/widgets/show_snak_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceForm extends StatefulWidget {
  final int groupId;
  final String groupName;

  const AttendanceForm({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final _notificationService = NotificationService();
  late String _currentDate;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _loadAttendance();
  }

  void _loadAttendance() {
    context.read<AttendanceBloc>().add(
          LoadGroupAttendance(widget.groupId, _currentDate),
        );
  }

  Future<void> _markAttendance(
    int studentId,
    String studentName,
    String phoneNumber,
    String status,
  ) async {
    final attendance = AttendanceDB(
      studentId: studentId,
      groupId: widget.groupId,
      date: _currentDate,
      status: status,
      comment: _commentController.text,
      timestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    context.read<AttendanceBloc>().add(MarkAttendance(attendance));

    // Отправляем уведомление
    final notificationSent =
        await _notificationService.sendAttendanceNotification(
      phoneNumber: phoneNumber,
      studentName: studentName,
      status: status,
      date: _currentDate,
      comment: _commentController.text,
    );

    if (notificationSent) {
      showSnackInfoBar(context, 'Уведомление отправлено');
    } else {
      showSnackInfoBar(context, 'Ошибка отправки уведомления');
    }

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Посещаемость - ${widget.groupName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _currentDate = DateFormat('yyyy-MM-dd').format(date);
                  _loadAttendance();
                });
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceError) {
            return Center(child: Text(state.message));
          }

          if (state is AttendanceLoaded) {
            return ListView.builder(
              itemCount: state.attendanceRecords.length,
              itemBuilder: (context, index) {
                final student = state.attendanceRecords[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      '${student.studentSurName} ${student.studentName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Статус: ${student.status}'),
                        if (student.comment != null && student.comment!.isNotEmpty)
                          Text('Комментарий: ${student.comment}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          switch (student.status) {
                            'present' => Icons.check_circle,
                            'late' => Icons.access_time,
                            'absent' => Icons.cancel,
                            _ => Icons.help_outline
                          },
                          color: switch (student.status) {
                            'present' => Colors.green,
                            'late' => Colors.orange,
                            'absent' => Colors.red,
                            _ => Colors.grey
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Нет данных о посещаемости'),
          );
        },
      ),
    );
  }

  Future<void> _showCommentDialog(
    int studentId,
    String studentName,
    String phoneNumber,
    String status,
  ) async {
    _commentController.clear();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить комментарий'),
        content: TextField(
          controller: _commentController,
          decoration: const InputDecoration(
            hintText: 'Введите причину отсутствия/опоздания',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _markAttendance(
                studentId,
                studentName,
                phoneNumber,
                status,
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
