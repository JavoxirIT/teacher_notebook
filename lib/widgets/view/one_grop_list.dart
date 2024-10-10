import 'dart:convert';

import 'package:assistant/bloc/group_bloc/group_bloc.dart';
import 'package:assistant/bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'package:assistant/bloc/student_in_a_group_bloc/student_in_a_group_bloc.dart';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/db/models/student_group_db_models.dart';
import 'package:assistant/db/student_add_group_repository.dart';
import 'package:assistant/style/clear_button_style.dart';
// import 'package:assistant/widgets/show_snak_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistant/db/models/group_db_models.dart';
import 'package:assistant/theme/style_constant.dart';

class OneGropList extends StatefulWidget {
  const OneGropList({super.key});

  @override
  _OneGropListState createState() => _OneGropListState();
}

class _OneGropListState extends State<OneGropList> {
  List<Map<String, dynamic>> dataUser = [];
  late GroupDB _group;
  // late Future<List<StudentGroupDBModels>> dataIsGroup;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    _group = setting.arguments as GroupDB;
    BlocProvider.of<StudentAndGroupListBloc>(context)
        .add(StudentAndGroupLoadEvent(_group.id));

    BlocProvider.of<StudentInAGroupBloc>(context)
        .add(StudentInAGroupEvent(_group.id));
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_group.groupName),
      ),
      body: Builder(
        builder: (context) {
          final stateStudentAndGroup =
              context.watch<StudentAndGroupListBloc>().state;

          final studentInAGroupState =
              context.watch<StudentInAGroupBloc>().state;
          // debugPrint('data: ${studentInAGroupState}');

          return Column(
            children: [
              SizedBox(
                // height: 30.0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: studentAtToGroup(context, stateStudentAndGroup),
                ),
              ),
              Expanded(
                child: studentData(context, studentInAGroupState),
              ),
            ],
          );
        },
      ),
    );
  }

  studentData(BuildContext context, state) {
    if (state is StudentInAGroupLoadState) {
      return ListView.builder(
        itemCount: state.data.length,
        itemBuilder: (context, i) {
          final item = state.data[i];
          return Card(
            child: Dismissible(
              key: Key(item.studentId.toString()),
              confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Внимание"),
                        content: const Text(
                            "Вы уверены? после удаления данные не восстановить!?"),
                        actions: <Widget>[
                          ElevatedButton(
                              style: clearButtonStyle,
                              onPressed: () {
                                Navigator.of(context).pop(true);
                                // StudentRepository.db.deleteStudent(item.id);
                                // BlocProvider.of<StudentBloc>(context)
                                //     .add(StudentEventLoad());
                              },
                              child: const Text("Удалить")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Нет"),
                          ),
                        ],
                      );
                    },
                  );
                } else if (direction == DismissDirection.endToStart) {
                  Navigator.of(context).pushNamed(
                    RouteName.payAdnPayAddView,
                    arguments: item,
                  );
                }
                return null;
              },
              // background: deleteBackgroundDismiss(),
              // secondaryBackground: secondaryBackgroundDismiss(),
              child: ListTile(
                // splashColor: const Color.fromARGB(255, 251, 189, 4),
                leading: CircleAvatar(
                  backgroundColor: colorGreen,
                  child: ClipOval(
                      child: item.studentImg != ""
                          ? Image.memory(
                              const Base64Decoder().convert(item.studentImg!),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : null),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                ),
                title: Text(item.studentName,
                    style: Theme.of(context).textTheme.bodyMedium),
                subtitle: Text(
                    item.studentPayStatus == 1 ? "Платно" : "Бесплатно",
                    style: Theme.of(context).textTheme.bodySmall),
                // onTap: () {

                // },
              ),
            ),
          );
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<List<StudentGroupDBModels>> getData() async =>
      await StudentAddGroupRepository.db.getDataGroup();

  TextButton studentAtToGroup(
      BuildContext context, StudentAndGroupListState state) {
    return TextButton(
      child: Row(
        children: [
          const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.person_add_outlined)),
          Text(
            "Добавить участника",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      onPressed: () => {
        state is StudentAndGroupLoadState
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return FractionallySizedBox(
                      heightFactor: 0.9,
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
                                        }
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  value: student.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      student.isSelected = value;
                                      addDataToList(student.studentsId,
                                          student.groupId, value);
                                    });
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
                  });
                },
              )
            : state is GroupStateLoading
                ? const Text("Загрузка....")
                : null
      },
    );
  }

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
    for (var i = 0; i < dataUser.length; i++) {
      StudentAddGroupRepository.db.addStudentToGroop(
        StudentGroupDBModels(
            studentId: dataUser[i]["studentId"],
            groupId: dataUser[i]["groupId"]),
      );
    }
  }
}
