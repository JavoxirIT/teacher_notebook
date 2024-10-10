import 'package:flutter/material.dart';

Container secondaryBackgroundDismiss() {
  return Container(
    color: Colors.green,
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: Center(
              child: Icon(
            Icons.edit,
            color: Colors.white,
          )),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Center(
            child: Text(
              "Изменить",
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
