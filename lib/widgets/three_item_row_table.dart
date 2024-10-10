import 'package:flutter/material.dart';

TableRow threeItemRowTable(context, String name, String summ, String date) {
  const padding = EdgeInsets.only(top: 10, bottom: 10, left: 10);
  final textTheme = Theme.of(context).textTheme.bodyMedium;
  return TableRow(
    children: <Widget>[
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(name, style: textTheme),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(summ, style: textTheme),
        ),
      ),
      TableCell(
        child: Padding(
          padding: padding,
          child: Text(date, style: textTheme),
        ),
      ),
    ],
  );
}
