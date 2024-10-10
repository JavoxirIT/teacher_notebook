import 'package:assistant/widgets/page_transitions.dart';
import 'package:assistant/style/outline_button_dark_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assistant/style/elevated_button_theme.dart';

final darkTheme = ThemeData(
  pageTransitionsTheme: pageTransitions(),
  // splashColor: Colors.amber,
  // primaryColor: Colors.greenAccent,
  // indicatorColor: Colors.indigo,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF1F1F1F),
    scrimColor: Color.fromARGB(111, 0, 0, 0),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  dividerTheme: const DividerThemeData(
    color: Color.fromARGB(255, 67, 67, 67),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Color.fromARGB(255, 99, 99, 99),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    bodyLarge: TextStyle(
      color: Colors.white, // <-- TextFormField input color
    ),
    headlineLarge: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20.0),
    headlineSmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.0),
  ),
  appBarTheme: const AppBarTheme(
    // elevation: 0,
    // color: Color.fromARGB(255, 55, 55, 55),
    color: Color.fromARGB(255, 31, 31, 31),
    foregroundColor: Color.fromARGB(255, 251, 189, 4),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    ),
  ),
  primarySwatch: Colors.yellow,
  // primaryIconTheme: const IconThemeData(color: Color.fromARGB(255, 182, 137, 2)),
  //  iconTheme: const IconThemeData(color: Colors.blue),
  listTileTheme: const ListTileThemeData(
    iconColor: Color.fromARGB(255, 251, 189, 4),
    selectedColor: Colors.white,
    // tileColor: Colors.amber,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color.fromARGB(255, 251, 189, 4),
      fontSize: 14,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 251, 189, 4),
      ),
    ),
    suffixIconColor: Color.fromARGB(255, 251, 189, 4),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: elevatedButtonTheme,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonDarkStyle),
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 0, 0, 0),
    shadowColor: Color.fromARGB(255, 251, 189, 4),
    elevation: 7.0,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(12.0),
    // ),
    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 10),
    surfaceTintColor: Color.fromARGB(255, 251, 189, 4),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color.fromARGB(255, 251, 189, 4),
    titleTextStyle: TextStyle(
      color: Color.fromARGB(255, 160, 14, 14),
      fontSize: 17.0,
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
    indicatorColor: Color.fromARGB(255, 251, 189, 4),
    dividerHeight: BorderSide.strokeAlignCenter,
    labelColor: Color.fromARGB(255, 251, 189, 4),
    overlayColor: MaterialStatePropertyAll(Colors.amber),
    // dividerColor: Colors.blueAccent
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    // backgroundColor: Color.fromARGB(255,251,189,4),
    backgroundColor: Color.fromARGB(255, 31, 31, 31),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: Colors.amberAccent,
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 5, 5),
      barBackgroundColor: Colors.blue),
  dropdownMenuTheme: const DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor:
          MaterialStatePropertyAll(Color.fromARGB(255, 251, 189, 4)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.deepOrangeAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    width: 280.0,
    insetPadding: const EdgeInsets.symmetric(
        horizontal: 8.0, vertical: 12.0 // Inner padding for SnackBar content.
        ),
  ),
);
