import 'package:TeamLead/bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'package:TeamLead/db/models/student_group_db_models.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAddToGroup extends StatefulWidget {
  const StudentAddToGroup({super.key, required this.id});

  final int id;

  @override
  State<StudentAddToGroup> createState() => _StudentAddToGroupState();
}

class _StudentAddToGroupState extends State<StudentAddToGroup> {
  List<Map<String, dynamic>> dataUser = [];

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.person_add_outlined,
                color: colorGreen,
              ),
            ),
            Text(
              "Добавить участника",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        onPressed: () => {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return BlocBuilder<StudentAndGroupListBloc,
                      StudentAndGroupListState>(
                    builder: (context, state) {
                      return FractionallySizedBox(
                        heightFactor: 1 - 0.1,
                        child: Column(
                          children: [
                            SizedBox(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        dataUser.clear();
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        "Отмена",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Text("Ученики"),
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        if (dataUser.isNotEmpty)
                                          {
                                            sendData(),
                                          },
                                        Navigator.of(context).pop(true)
                                      },
                                      child: Text(
                                        "Готово",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ]),
                            ),
                            if (state is StudentAndGroupLoadState)
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.data.length,
                                  // separatorBuilder: (context, index) =>
                                  //     const Divider(color: Color.fromARGB(255, 145, 145, 145)),

                                  itemBuilder: (context, index) {
                                    final student = state.data[index];
                                    return CheckboxListTile(
                                      tileColor: student.isSelected == true
                                          ? coloR0xFFDAE3E4
                                          : null,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        '${student.studentName} ${student.studentSurName}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      value: student.isSelected,
                                      onChanged: (value) {
                                        BlocProvider.of<
                                                    StudentAndGroupListBloc>(
                                                context)
                                            .add(
                                          StudentAndGroupSelectionEvent(
                                            studentId: student.studentsId,
                                            isSelected: value!,
                                          ),
                                        );
                                        addDataToList(
                                          student.studentsId,
                                          student.groupId,
                                          value,
                                        );
                                      },
                                      checkColor: colorGreen,
                                      activeColor: colorWhite,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            });
  }

  // Future<List<StudentGroupDBModels>> getData() async =>
  //     await StudentAddGroupRepository.db.getDataGroup();

  void addDataToList(studentsId, groupId, isSelected) {
    final Map<String, dynamic> data = {
      'id': null,
      "studentId": studentsId,
      'groupId': groupId,
      'isSelected': isSelected
    };

    if (data['isSelected'] == true) {
      dataUser.add(data);
    } else if (data['isSelected'] == false) {
      dataUser
          .removeWhere((element) => element['studentId'] == data['studentId']);
    }
  }

  void sendData() {
    int timestampSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    for (var i = 0; i < dataUser.length; i++) {
      // log('studentId: ${dataUser[i]["studentId"]}');
      // log('groupId: ${dataUser[i]["groupId"]}');

      StudentAddGroupRepository.db.addStudentToGroup(
        StudentGroupDBModels(
          studentId: dataUser[i]["studentId"],
          groupId: dataUser[i]["groupId"],
          studentGroupStatus: 1,
          startDate: timestampSeconds,
        ),
      );
    }
  }
}
