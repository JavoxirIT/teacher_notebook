import 'dart:convert';

import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';

ListTile listTileData(StudentDB item, BuildContext context) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: colorGreen,
      child: ClipOval(
        child: _buildStudentImage(item.studentImg),
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
      item.studentPhone,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    onTap: () {
      Navigator.of(context).pushNamed(
        RouteName.oneStudentView,
        arguments: item,
      );
    },
  );
}

Widget? _buildStudentImage(String? imageData) {
  if (imageData == null || imageData.isEmpty) {
    return null;
  }

  try {
    return Image.memory(
      base64Decode(imageData),
      fit: BoxFit.cover,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading image: $error');
        return Icon(Icons.person, size: 50);
      },
    );
  } catch (e) {
    debugPrint('Error decoding image: $e');
    return null;
  }
}
