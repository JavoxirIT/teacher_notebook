import 'package:flutter/material.dart';

final ButtonStyle clearButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: const Color.fromARGB(255, 160, 14, 14),
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
  shadowColor: const Color.fromARGB(255, 255, 255, 255),
);
