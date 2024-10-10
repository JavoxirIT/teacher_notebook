import 'package:flutter/material.dart';

final ButtonStyle elevatedButtonTheme = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: const Color.fromARGB(255, 251, 189, 4),
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
  textStyle: const TextStyle(
    fontSize: 14
  ),
  shadowColor: const Color.fromARGB(255, 27, 27, 27)
);
