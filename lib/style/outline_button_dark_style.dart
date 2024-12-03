import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';

final ButtonStyle outlineButtonDarkStyle = ElevatedButton.styleFrom(
    foregroundColor: colorWhite,
    backgroundColor: darkGrey,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(22),
      ),
    ),
    textStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
    ),
    shadowColor: colorWhite,
    side: const BorderSide(
      color: colorWhite,
    ),
    elevation: 3.0);
