import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:flutter/material.dart';

class GroupCardItem extends StatefulWidget {
  const GroupCardItem({super.key, required this.group});
  final GroupDB group;
  @override
  State<GroupCardItem> createState() => _GroupCardItemState();
}

class _GroupCardItemState extends State<GroupCardItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
      title: Text(widget.group.groupName,
          style: Theme.of(context).textTheme.headlineLarge),
      subtitle: Text(
          '${widget.group.groupDays == 1 ? "ПН-СР-ПТ" : "ВТ-ЧТ-СУ"} ${widget.group.groupTimes}',
          style: Theme.of(context).textTheme.labelSmall),
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteName.oneGroupListView,
          arguments: widget.group,
        );
      },
    );
  }
}
