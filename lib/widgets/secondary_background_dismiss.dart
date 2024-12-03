import 'package:flutter/material.dart';

Container secondaryBackgroundDismiss(String label) {
  return Container(
    color: Colors.green,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: Center(
              child: Icon(
            Icons.edit,
            color: Colors.white,
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
