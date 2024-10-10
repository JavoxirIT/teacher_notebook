import 'package:flutter/material.dart';

const greenCustomColor = Color.fromRGBO(39, 174, 96, 1);

final ButtonStyle outlineButtonGreenStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: greenCustomColor,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(22),
    ),
  ),
  textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
  shadowColor: greenCustomColor,
  side: const BorderSide(
    color: greenCustomColor,
  ),
  elevation: 7.0,
);
