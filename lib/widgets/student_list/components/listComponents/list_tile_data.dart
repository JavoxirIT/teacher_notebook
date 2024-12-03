import 'dart:convert';

import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';

ListTile listTileData(StudentDB item, BuildContext context) {
  return ListTile(
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
    title:
        Text(item.studentName, style: Theme.of(context).textTheme.bodyMedium),
    subtitle:
        Text(item.studentPhone, style: Theme.of(context).textTheme.bodySmall),
    onTap: () {
      Navigator.of(context).pushNamed(
        RouteName.oneStudentView,
        arguments: item,
      );
    },
  );
}
