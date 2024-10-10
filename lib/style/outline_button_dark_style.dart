import 'package:flutter/material.dart';

final ButtonStyle outlineButtonDarkStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: const Color.fromARGB(255, 251, 189, 4),
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(22),
    ),
  ),
  textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
  shadowColor: const Color.fromARGB(255, 251, 189, 4),
  side: const BorderSide(
    color: Color.fromARGB(255, 251, 189, 4),
  ),
  elevation: 7.0
);
