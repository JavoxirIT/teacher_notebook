import 'dart:io';
import 'package:TeamLead/bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'package:TeamLead/db/models/student_group_db_models.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAddToGroup extends StatefulWidget {
  const StudentAddToGroup({super.key, required this.id});

  final int id;

  @override
  State<StudentAddToGroup> createState() => _StudentAddToGroupState();
}

class _StudentAddToGroupState extends State<StudentAddToGroup> {
  List<Map<String, dynamic>> dataUser = [];
  final Set<int> _selectedStudents = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context
        .read<StudentAndGroupListBloc>()
        .add(StudentAndGroupLoadEvent(widget.id));
  }

  void _toggleStudentSelection(int studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }
    });
  }

  Future<void> _addSelectedStudents() async {
    if (_selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите хотя бы одного студента'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bool hasErrors = false;
    int successCount = 0;

    for (final studentId in _selectedStudents) {
      final studentData = StudentGroupDBModels(
        studentId: studentId,
        groupId: widget.id,
        studentGroupStatus: 1,
        startDate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      final result = await StudentAddGroupRepository.db.addStudentToGroup(studentData);
      if (result != null) {
        successCount++;
      } else {
        hasErrors = true;
      }
    }

    if (mounted) {
      if (successCount > 0) {
        context.read<StudentAndGroupListBloc>().add(StudentAndGroupLoadEvent(widget.id));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Добавлено студентов: $successCount'),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (hasErrors) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Некоторые студенты уже состоят в группе'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добавить участников',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Выбрано: ${_selectedStudents.length}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _selectedStudents.isEmpty ? null : _addSelectedStudents,
            child: Text(
              'Добавить',
              style: TextStyle(
                fontSize: 17,
                color: _selectedStudents.isEmpty
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: CupertinoColors.systemGroupedBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CupertinoSearchTextField(
              placeholder: 'Поиск',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<StudentAndGroupListBloc, StudentAndGroupListState>(
              builder: (context, state) {
                if (state is StudentAndGroupLoadState) {
                  if (state.data.isEmpty) {
                    return Center(
                      child: Text(
                        'Нет доступных студентов',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final student = state.data[index];
                      if (_searchQuery.isNotEmpty &&
                          !student.studentName
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())) {
                        return const SizedBox();
                      }
                      return Container(
                        color: CupertinoColors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            backgroundImage: student.studentImg != null
                                ? FileImage(File(student.studentImg!))
                                : null,
                            onBackgroundImageError: student.studentImg != null
                                ? (exception, stackTrace) {
                                    debugPrint('Error loading image: $exception');
                                  }
                                : null,
                            child: student.studentImg == null
                                ? Text(
                                    student.studentName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            student.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            student.studentSurName ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: _selectedStudents.contains(student.studentsId)
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                ),
                          onTap: () => _toggleStudentSelection(student.studentsId),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
