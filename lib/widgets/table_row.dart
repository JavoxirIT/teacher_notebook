import 'package:flutter/material.dart';

TableRow tableRow(context, name, value) {
  return TableRow(
    children: <Widget>[
      TableCell(
        child: Text(name),
      ),
      TableCell(
          child: Text(value, style: Theme.of(context).textTheme.titleSmall))
    ],
  );
}
