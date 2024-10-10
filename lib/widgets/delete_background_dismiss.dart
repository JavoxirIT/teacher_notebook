import 'package:flutter/material.dart';

Container deleteBackgroundDismiss() {
  return Container(
    color: Colors.red,
    child: const Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Center(
              child: Icon(
            Icons.delete,
            color: Colors.white,
          )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Center(
            child: Text(
              "Удалить",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
