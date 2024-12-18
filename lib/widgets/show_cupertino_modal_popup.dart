import 'package:TeamLead/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCupModalPopup(
    Widget child, BuildContext context, double height) {
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Container(
      // height: 350,
      // padding: const EdgeInsets.only(top: 6.0),
      // margin: EdgeInsets.only(
      //   bottom: MediaQuery.of(context).viewInsets.bottom,
      // ),
      // color: colorGrey200,
      // Use a SafeArea widget to avoid system overlaps.
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            20.0,
          ),
          topRight: Radius.circular(
            20.0,
          ),
        ),
        color: colorBlue,
      ),
      height: height,
      child: CupertinoTheme(
        data: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle:
                TextStyle(color: colorWhite, fontSize: 24.0),
          ),
          // brightness: Brightness.dark,
          barBackgroundColor: Colors.amber,
        ),
        child: child,
      ),
    ),
  );
}
