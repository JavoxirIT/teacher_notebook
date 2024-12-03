import 'package:flutter/material.dart';

TableRow threeItemRowTable(
  BuildContext context,
  String number,
  String name,
  String summ,
  String date,
  Color backgroundColor, // Добавляем параметр для цвета фона
) {
  const padding = EdgeInsets.only(top: 10, bottom: 10, left: 10);
  final textTheme = Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12.0);

  return TableRow(
    children: <Widget>[
      TableCell(
        child: Container(
          color: backgroundColor, // Устанавливаем цвет фона
          child: Padding(
            padding: padding,
            child: Text(number.toString(), style: textTheme),
          ),
        ),
      ),
      TableCell(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: padding,
            child: Text(name, style: textTheme),
          ),
        ),
      ),
      TableCell(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: padding,
            child: Text(summ, style: textTheme),
          ),
        ),
      ),
      TableCell(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: padding,
            child: Text(date, style: textTheme),
          ),
        ),
      ),
    ],
  );
}