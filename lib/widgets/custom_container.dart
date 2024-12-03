import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.color,
    required this.widgets,
    this.mm,
    this.pp,
  });
  final Color? color;
  final Widget widgets;
  final double? mm;
  final double? pp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(pp ?? 10.0),
      margin: EdgeInsets.all(mm ?? 10.0),
      decoration: BoxDecoration(
        color: color ?? colorWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: widgets,
    );
  }
}
