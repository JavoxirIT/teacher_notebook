import 'package:TeamLead/style/elevated_button_theme.dart';
import 'package:TeamLead/style/outlone_button_light_style.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/page_transitions.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  pageTransitionsTheme: pageTransitions(),
  // splashColor: Colors.amber,
  // primaryColor: Colors.greenAccent,
  // indicatorColor: Colors.indigo,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    scrimColor: Color.fromARGB(103, 58, 58, 58),
  ),
  // scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
  dividerTheme: const DividerThemeData(
    color: Color.fromARGB(255, 136, 0, 0),
  ),
  iconTheme: const IconThemeData(color: colorGreen),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 16.0,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 12.0,
    ),
  ),
  appBarTheme: const AppBarTheme(
    // elevation: 0,
    // color: Color.fromARGB(255, 55, 55, 55),
    color: Color.fromARGB(255, 255, 255, 255),
    // foregroundColor: Color.fromARGB(255, 251, 189, 4),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    ),
  ),
  primarySwatch: Colors.yellow,
  // primaryIconTheme: const IconThemeData(color: Color.fromARGB(255, 182, 137, 2)),
  //  iconTheme: const IconThemeData(color: Colors.blue),
  listTileTheme: const ListTileThemeData(
    iconColor: colorGreen,
    selectedColor: Colors.white,
    // tileColor: Colors.amber,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(
      color: darkGrey,
      fontSize: 14,
    ),
    suffixIconColor: ember,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Уменьшить радиус закругления
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Для неактивного состояния
      borderSide: BorderSide(color: darkGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // Для активного состояния
      borderSide: BorderSide(color: darkGrey, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: elevatedButtonTheme,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonLightStyle),
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 255, 255, 255),
    shadowColor: Colors.black,
    elevation: 7.0,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(12.0),
    // ),
    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 10),
    // surfaceTintColor: Color.fromARGB(255, 90, 90, 90),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    titleTextStyle: TextStyle(
      color: Color.fromARGB(255, 102, 17, 17),
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
    ),
    shadowColor: Color.fromARGB(255, 160, 14, 14),
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)))
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(30.0, 15.0)))
    // this.contentTextStyle,
  ),
  // hintColor: Colors.yellow,
  // hoverColor: Colors.blue
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    indicatorColor: Colors.black,
    dividerHeight: BorderSide.strokeAlignCenter,
    labelColor: Colors.black,
    overlayColor: WidgetStatePropertyAll(Colors.amber),
    // dividerColor: Colors.blueAccent
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    // backgroundColor: Color.fromARGB(255,251,189,4),
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
  ),
);
