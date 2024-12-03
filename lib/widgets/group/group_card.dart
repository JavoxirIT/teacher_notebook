import 'package:TeamLead/bloc/group_bloc/group_bloc.dart';
import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/widgets/delete_background_dismiss.dart';
import 'package:TeamLead/widgets/group/group_card_item.dart';
import 'package:TeamLead/widgets/secondary_background_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCard extends StatefulWidget {
  const GroupCard({super.key, required this.group});

  final GroupDB group;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: Key(widget.group.id.toString()),
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
                            .add(GroupEventDelete(widget.group.id!));
                        // BlocProvider.of<GroupBloc>(context).add(GroupEventLoad());
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
              arguments: widget.group,
            );
          }
          return null;
        },
        background: deleteBackgroundDismiss(),
        secondaryBackground: secondaryBackgroundDismiss("Изменить"),
        child: GroupCardItem(group: widget.group),
      ),
    );
  }
}
