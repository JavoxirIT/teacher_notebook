import 'package:TeamLead/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  const AttendanceHistoryScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      if (!mounted) return;
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      debugPrint('Selected new date: $formattedDate');
      context.read<AttendanceBloc>().add(LoadGroupAttendance(
        widget.groupId,
        formattedDate,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('AttendanceHistoryScreen initialized');
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    final today = DateFormat('yyyy-MM-dd').format(selectedDate);
    debugPrint('Loading attendance for date: $today');
    context.read<AttendanceBloc>().add(LoadGroupAttendance(
      widget.groupId,
      today,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История посещений - ${widget.groupName}'),
      ),
      body: Column(
        children: [
          // Календарь или выбор даты
          Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                DateFormat('dd MMMM yyyy').format(selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => _selectDate(context),
            ),
          ),

          // Список посещаемости
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AttendanceLoaded) {
                  if (state.attendanceRecords.isEmpty) {
                    return const Center(
                      child: Text('Нет данных о посещаемости на эту дату'),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final attendance = state.attendanceRecords[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: ListTile(
                          title: Text(
                            '${attendance.studentSurName} ${attendance.studentName}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    switch (attendance.status) {
                                      'present' => Icons.check_circle,
                                      'late' => Icons.access_time,
                                      'absent' => Icons.cancel,
                                      _ => Icons.help_outline
                                    },
                                    color: switch (attendance.status) {
                                      'present' => Colors.green,
                                      'late' => Colors.orange,
                                      'absent' => Colors.red,
                                      _ => Colors.grey
                                    },
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    switch (attendance.status) {
                                      'present' => 'Присутствовал',
                                      'late' => 'Опоздал',
                                      'absent' => 'Отсутствовал',
                                      _ => 'Не отмечен'
                                    },
                                  ),
                                ],
                              ),
                              if (attendance.comment != null &&
                                  attendance.comment!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Комментарий: ${attendance.comment}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Text(
                            DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                attendance.timestampSeconds * 1000,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is AttendanceError) {
                  return Center(
                    child: Text('Ошибка: ${state.message}'),
                  );
                }
                return const Center(
                  child: Text('Выберите дату для просмотра посещаемости'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
