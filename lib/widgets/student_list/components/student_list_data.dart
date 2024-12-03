import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/widgets/delete_background_dismiss.dart';
import 'package:TeamLead/widgets/secondary_background_dismiss.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

import 'listComponents/list_tile_data.dart';

Card studentListData(BuildContext context, StudentDB item) {
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
                        StudentRepository.db.deleteStudent(item.id);
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
            RouteName.localSudentUpdate,
            arguments: item,
          );
        }
        return null;
      },
      background: deleteBackgroundDismiss(),
      secondaryBackground: secondaryBackgroundDismiss("Изменить"),
      child: listTileData(item, context),
    ),
  );
}
