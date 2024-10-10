import 'package:assistant/bloc/group_bloc/group_bloc.dart';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/db/models/group_db_models.dart';
import 'package:assistant/style/clear_button_style.dart';
import 'package:assistant/widgets/delete_background_dismiss.dart';
import 'package:assistant/widgets/group/group_card_item.dart';
import 'package:assistant/widgets/secondary_background_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Card groupCard(BuildContext context, GroupDB group) {
  return Card(
    child: Dismissible(
      key: Key(group.id.toString()),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Внимание"),
                content: const Text(
                  "Вы уверены? после удаления данные не восстановить!?",
                  // style: Theme.of(context).textTheme.titleSmall,
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: clearButtonStyle,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      BlocProvider.of<GroupBloc>(context)
                          .add(GroupEventDelete(group.id!));
                      BlocProvider.of<GroupBloc>(context).add(GroupEventLoad());
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
            RouteName.groupUpdateAddForm,
            arguments: group,
          );
        }
        return null;
      },
      background: deleteBackgroundDismiss(),
      secondaryBackground: secondaryBackgroundDismiss(),
      child: groupCardItem(group, context),
    ),
  );
}
