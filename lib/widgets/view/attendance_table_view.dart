import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:TeamLead/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceTableView extends StatefulWidget {
  final List<StudentInAGroupModels> students;
  final List<AttendanceDB> attendanceRecords;
  final DateTime selectedMonth;

  const AttendanceTableView({
    super.key,
    required this.students,
    required this.attendanceRecords,
    required this.selectedMonth,
  });

  @override
  State<AttendanceTableView> createState() => _AttendanceTableViewState();
}

class _AttendanceTableViewState extends State<AttendanceTableView> {
  String? _statusFilter;
  bool _isEditing = false;
  final Set<int> _selectedStudents = {};
  DateTime _selectedDate = DateTime.now();

  // Добавляем статистику по дням недели
  Map<int, Map<String, int>> _weekdayStats = {};

  @override
  void initState() {
    super.initState();
    _calculateWeekdayStats();
  }

  void _calculateWeekdayStats() {
    _weekdayStats.clear();
    for (var record in widget.attendanceRecords) {
      final date = DateTime.parse(record.date);
      final weekday = date.weekday;

      _weekdayStats.putIfAbsent(weekday, () => {'5': 0, '4': 0, '2': 0});

      final status = switch (record.status) {
        'present' => '5',
        'late' => '4',
        'absent' => '2',
        _ => '',
      };

      if (status.isNotEmpty) {
        _weekdayStats[weekday]![status] = (_weekdayStats[weekday]![status] ?? 0) + 1;
      }
    }
  }

  Future<void> _exportToExcel() async {
    try {
      // Показываем индикатор загрузки
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Создаем отчет...'),
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

      final excelFile = excel.Excel.createExcel();
      final sheet = excelFile['Посещаемость'];
      
      // Заголовок с информацией о группе и месяце
      sheet.merge(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
                excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
      sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = 'Отчет за ${DateFormat('MMMM yyyy', 'ru').format(widget.selectedMonth)}';
      
      // Заголовки столбцов
      int row = 2;
      sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = 'Ученик';
      
      final days = _getDaysInMonth();
      for (var i = 0; i < days.length; i++) {
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: row))
          .value = DateFormat('d (E)', 'ru').format(days[i]);
      }
      
      // Данные учеников
      for (var student in widget.students) {
        row++;
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = '${student.studentName} ${student.studentSurName}';
        
        for (var i = 0; i < days.length; i++) {
          final date = DateFormat('yyyy-MM-dd').format(days[i]);
          final status = _getAttendanceStatus(student.studentId, date);
          sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: row))
            .value = status;
        }
      }
      
      // Статистика по дням недели
      row += 2;
      sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = 'Статистика по дням недели';
        
      final weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
      for (var i = 0; i < weekdays.length; i++) {
        row++;
        final stats = _weekdayStats[i + 1] ?? {'5': 0, '4': 0, '2': 0};
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = weekdays[i];
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = 'Присутствовали: ${stats['5']}';
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = 'Опоздали: ${stats['4']}';
        sheet.cell(excel.CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = 'Отсутствовали: ${stats['2']}';
      }
      
      // Сохраняем файл
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'attendance_${DateFormat('yyyy_MM').format(widget.selectedMonth)}.xlsx';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(excelFile.encode()!);
      
      // Делимся файлом
      if (!mounted) return;
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Отчет посещаемости за ${DateFormat('MMMM yyyy', 'ru').format(widget.selectedMonth)}',
      );
      
      // Показываем результат
      if (!mounted) return;
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Файл успешно отправлен'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось отправить файл: ${result.status}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при экспорте: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _toggleGroupEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _selectedStudents.clear();
      }
    });
  }

  void _markGroupAttendance(String status) {
    if (_selectedStudents.isEmpty) return;

    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    for (final studentId in _selectedStudents) {
      final attendance = AttendanceDB(
        studentId: studentId,
        groupId: widget.students.first.groupId,
        date: date,
        status: switch (status) {
          '5' => 'present',
          '4' => 'late',
          '2' => 'absent',
          _ => 'present',
        },
        timestampSeconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      
      context.read<AttendanceBloc>().add(MarkAttendance(attendance));
    }
    
    // Показываем уведомление об успешной отметке
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Отмечено ${_selectedStudents.length} учеников на ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'
        ),
        backgroundColor: Colors.green,
      ),
    );
    
    // Очищаем выбранных студентов
    setState(() {
      _selectedStudents.clear();
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);
    final lastDay = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0);
    final days = <DateTime>[];

    for (var i = firstDay; i.isBefore(lastDay.add(const Duration(days: 1))); i = i.add(const Duration(days: 1))) {
      days.add(i);
    }

    return days;
  }

  String _getAttendanceStatus(int studentId, String date) {
    final record = widget.attendanceRecords.firstWhere(
      (record) => record.studentId == studentId && record.date == date,
      orElse: () => AttendanceDB(
        studentId: -1,
        groupId: -1,
        date: '',
        status: '',
        timestampSeconds: 0,
        isNotified: false,
      ),
    );

    return switch (record.status) {
      'present' => '5',
      'late' => '4',
      'absent' => '2',
      _ => '',
    };
  }

  Map<String, int> _getStudentStats(int studentId) {
    final stats = {'5': 0, '4': 0, '2': 0};
    final studentRecords = widget.attendanceRecords
        .where((record) => record.studentId == studentId)
        .map((record) => switch (record.status) {
              'present' => '5',
              'late' => '4',
              'absent' => '2',
              _ => '',
            })
        .where((status) => status.isNotEmpty);

    for (final status in studentRecords) {
      stats[status] = (stats[status] ?? 0) + 1;
    }

    return stats;
  }

  bool _shouldShowStudent(StudentInAGroupModels student) {
    if (_statusFilter == null) return true;

    final stats = _getStudentStats(student.studentId);
    return stats[_statusFilter]! > 0;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    final filteredStudents = widget.students.where(_shouldShowStudent).toList();

    return Column(
      children: [
        // Кнопки действий и фильтры
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопки действий
                Row(
                  children: [
                    // Кнопка экспорта
                    ElevatedButton.icon(
                      onPressed: _exportToExcel,
                      icon: const Icon(Icons.file_download),
                      label: const Text('Экспорт'),
                    ),
                    const SizedBox(width: 8),
                    // Кнопка группового редактирования
                    ElevatedButton.icon(
                      onPressed: _toggleGroupEdit,
                      icon: Icon(_isEditing ? Icons.close : Icons.edit),
                      label: Text(_isEditing ? 'Отмена' : 'Групповое редактирование'),
                    ),
                    if (_isEditing) ...[
                      const SizedBox(width: 8),
                      // Кнопка выбора даты
                      OutlinedButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                      ),
                    ],
                    if (_isEditing && _selectedStudents.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _markGroupAttendance('5'),
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        tooltip: 'Отметить присутствие',
                      ),
                      IconButton(
                        onPressed: () => _markGroupAttendance('4'),
                        icon: const Icon(Icons.access_time, color: Colors.orange),
                        tooltip: 'Отметить опоздание',
                      ),
                      IconButton(
                        onPressed: () => _markGroupAttendance('2'),
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        tooltip: 'Отметить отсутствие',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // Фильтры
                Row(
                  children: [
                    const Text('Фильтр: '),
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Все'),
                          selected: _statusFilter == null,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _statusFilter = null);
                            }
                          },
                        ),
                        FilterChip(
                          label: const Text('Присутствовал'),
                          selected: _statusFilter == '5',
                          selectedColor: Colors.green.withOpacity(0.2),
                          onSelected: (selected) {
                            setState(() => _statusFilter = selected ? '5' : null);
                          },
                        ),
                        FilterChip(
                          label: const Text('Опоздал'),
                          selected: _statusFilter == '4',
                          selectedColor: Colors.orange.withOpacity(0.2),
                          onSelected: (selected) {
                            setState(() => _statusFilter = selected ? '4' : null);
                          },
                        ),
                        FilterChip(
                          label: const Text('Отсутствовал'),
                          selected: _statusFilter == '2',
                          selectedColor: Colors.red.withOpacity(0.2),
                          onSelected: (selected) {
                            setState(() => _statusFilter = selected ? '2' : null);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Таблица
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(
                  dataTableTheme: DataTableThemeData(
                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                    columnSpacing: 20,
                    horizontalMargin: 12,
                  ),
                ),
                child: DataTable(
                  columns: [
                    if (_isEditing)
                      const DataColumn(label: SizedBox(width: 24)),
                    const DataColumn(
                      label: Text(
                        'Ученики',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...days.map((day) => DataColumn(
                          label: Column(
                            children: [
                              Text(
                                DateFormat('d').format(day),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('E', 'ru').format(day),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const DataColumn(
                      label: Text(
                        'Итого',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    filteredStudents.length,
                    (index) {
                      final student = filteredStudents[index];
                      final stats = _getStudentStats(student.studentId);
                      
                      return DataRow(
                        selected: _selectedStudents.contains(student.studentId),
                        onSelectChanged: _isEditing
                            ? (selected) {
                                setState(() {
                                  if (selected == true) {
                                    _selectedStudents.add(student.studentId);
                                  } else {
                                    _selectedStudents.remove(student.studentId);
                                  }
                                });
                              }
                            : null,
                        cells: [
                          if (_isEditing)
                            DataCell(
                              Checkbox(
                                value: _selectedStudents.contains(student.studentId),
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected == true) {
                                      _selectedStudents.add(student.studentId);
                                    } else {
                                      _selectedStudents.remove(student.studentId);
                                    }
                                  });
                                },
                              ),
                            ),
                          DataCell(
                            Text('${student.studentName} ${student.studentSurName}'),
                          ),
                          ...days.map((day) {
                            final date = DateFormat('yyyy-MM-dd').format(day);
                            final status = _getAttendanceStatus(student.studentId, date);
                            final color = switch (status) {
                              '5' => Colors.green,
                              '4' => Colors.orange,
                              '2' => Colors.red,
                              _ => Colors.grey,
                            };

                            return DataCell(
                              Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StatBadge(count: stats['5'] ?? 0, color: Colors.green),
                              const SizedBox(width: 4),
                              _StatBadge(count: stats['4'] ?? 0, color: Colors.orange),
                              const SizedBox(width: 4),
                              _StatBadge(count: stats['2'] ?? 0, color: Colors.red),
                            ],
                          )),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final int count;
  final Color color;

  const _StatBadge({
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
