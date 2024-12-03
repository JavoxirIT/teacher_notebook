import 'dart:convert';

import 'package:TeamLead/bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'package:TeamLead/bloc/student_in_a_group_bloc/student_in_a_group_bloc.dart';
import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/delete_background_dismiss.dart';
import 'package:TeamLead/widgets/secondary_background_dismiss.dart';
import 'package:TeamLead/widgets/view/view_widgets/student_add_to_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OneGroupList extends StatefulWidget {
  const OneGroupList({super.key});

  @override
  State<OneGroupList> createState() => _OneGroupListState();
}

class _OneGroupListState extends State<OneGroupList> {
  late GroupDB group;
  // late Future<List<StudentGroupDBModels>> dataIsGroup;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    group = setting.arguments as GroupDB;
    BlocProvider.of<StudentAndGroupListBloc>(context)
        .add(StudentAndGroupLoadEvent(group.id));

    BlocProvider.of<StudentInAGroupBloc>(context)
        .add(StudentInAGroupEvent(group.id));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.groupName),
      ),
      body: BlocBuilder<StudentInAGroupBloc, StudentInAGroupBlockState>(
        builder: (context, state) {
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
                  child: StudentAddToGroup(id: group.id!),
                ),
              ),
              Expanded(
                child: studentData(context, state),
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
              key: Key(item.id.toString()),
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
                              BlocProvider.of<StudentInAGroupBloc>(context).add(
                                StudentInAGroupDeleteEvent(
                                  id: item.id,
                                  studentId: item.studentId,
                                ),
                              );
                              setState(() {
                                state.data.removeAt(i);
                              });
                            },
                            child: const Text("Удалить"),
                          ),
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
                    arguments: {"dataStudent": item, "groupId": group.id},
                  );
                }
                return null;
              },
              background: deleteBackgroundDismiss(),
              secondaryBackground: secondaryBackgroundDismiss("Оплата"),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // Волна на заднем плане
                    Positioned.fill(
                      child: CustomPaint(
                        painter: WavePainter(
                          isStatus(
                            item,
                            group.id ?? 0,
                          ),
                        ),
                      ),
                    ),
                    // Сам ListTile
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorGreen,
                        child: ClipOval(
                          child: item.studentImg != ""
                              ? Image.memory(
                                  const Base64Decoder()
                                      .convert(item.studentImg!),
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                )
                              : null,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                      title: Text(
                        item.studentName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        item.studentPayStatus == 1 ? "Платно" : "Бесплатно",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        // Действие при нажатии
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    if (state is StudentInAGroupBlockInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Группа пуста",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "добавьте участников",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }

  isStatus(StudentInAGroupModels item, int groupId) {
    final formater = DateFormat("MM/yyyy");
    DateTime date = DateTime.now();
    String todaysDay = formater.format(date);
    String studeInsetGroupStartData = formater
        .format(DateTime.fromMillisecondsSinceEpoch(item.startingDate * 1000));
    String lastPaymentDate = formater.format(
        DateTime.fromMillisecondsSinceEpoch(
            item.lastPaymentDateTimeStamp * 1000));
    int? lastPaymentInGroup = item.lastPaymentInGroup;

    // bool isDataResult =
    //     formater.parse(todaysDay).isAfter(formater.parse(lastPaymentDate));

    bool isDataResult2 =
        formater.parse(todaysDay).isAfter(formater.parse(lastPaymentDate));

    bool isEquals = formater
        .parse(lastPaymentDate)
        .isAtSameMomentAs(formater.parse(todaysDay));

    if (item.studentPayStatus == 1) {
      // if (lastPaymentInGroup == groupId) {
      if (isDataResult2) {
        return Colors.red[200];
      } else if (isEquals) {
        return colorBlue;
      }
      // }
    }
    return colorGrey200;
  }
}

class WavePainter extends CustomPainter {
  final Color waveColor;

  WavePainter(this.waveColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // Верхняя часть
    // path.quadraticBezierTo(
    //     size.width * 1.4, size.height * 0.4, 0, size.height * 1);

    path.quadraticBezierTo(size.width * 1.3, size.height * 0.4, 0,
        size.height * 3); // Большая волна
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Перерисовка не нужна, если данные остаются неизменными
  }
}

class ZigZagWavePainter extends CustomPainter {
  final Color waveColor;

  ZigZagWavePainter(this.waveColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // Начало сверху

    // Создаем зигзаг
    const double zigZagHeight = 20; // Высота одного зигзага
    const double zigZagWidth = 30; // Ширина одного зигзага
    double currentX = 0;
    bool goingDown = true;

    while (currentX < size.width) {
      if (goingDown) {
        path.lineTo(currentX, zigZagHeight);
      } else {
        path.lineTo(currentX, 0);
      }
      currentX += zigZagWidth;
      goingDown = !goingDown;
    }

    // Завершаем волну
    path.lineTo(size.width, size.height); // Вниз вправо
    path.lineTo(0, size.height); // Вниз влево
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Перерисовка не нужна, если данные остаются неизменными
  }
}
