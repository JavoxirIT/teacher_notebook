import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/db/models/group_db_models.dart';
import 'package:flutter/material.dart';

ListTile groupCardItem(GroupDB group, BuildContext context) {
  String groupDays = group.groupDays == "1" ? "ПН-СР-ПТ" : "ВТ-ЧТ-СУ";

  return ListTile(
    trailing: const Icon(
      Icons.arrow_forward_ios,
    ),
    title: Text(group.groupName, style: Theme.of(context).textTheme.bodyMedium),
    subtitle: Text('$groupDays ${group.groupTimes}',
        style: Theme.of(context).textTheme.bodySmall),
    onTap: () {
      Navigator.of(context).pushNamed(
        RouteName.oneGroupListView,
        arguments: group,
      );
    },
  );
}
