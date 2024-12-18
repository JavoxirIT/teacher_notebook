import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackInfoBar(
    context, text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colorWhite,
      content: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: Colors.red),
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}
