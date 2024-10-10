import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackInfoBar(
    context, text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    
      content: Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
