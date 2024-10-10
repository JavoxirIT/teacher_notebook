import 'package:assistant/style/text_button_style_green.dart';
import 'package:assistant/theme/style_constant.dart';
import 'package:assistant/widgets/page_transitions.dart';
import 'package:assistant/style/outline_button_green_style.dart';
import 'package:flutter/material.dart';
import 'package:assistant/style/elevated_button_theme.dart';
import 'package:google_fonts/google_fonts.dart';

final greenTheme = ThemeData(
  unselectedWidgetColor: colorWhite,
  pageTransitionsTheme: pageTransitions(),
  // splashColor: Colors.amber,
  // primaryColor: Colors.greenAccent,
  // indicatorColor: Colors.indigo,
  drawerTheme: const DrawerThemeData(
    backgroundColor: colorGreen,
    scrimColor: Color.fromARGB(103, 58, 58, 58),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  dividerTheme: const DividerThemeData(
    color: Color.fromARGB(255, 39, 39, 39),
  ),
  fontFamily: GoogleFonts.montserrat().fontFamily,
  textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: coloR0xFF707B7C,
        fontWeight: FontWeight.w800,
        fontSize: 12,
      ),
      bodySmall: TextStyle(
        color: coloR0xFFB2BABB,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      titleSmall: TextStyle(
        color: colorWhite,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      titleLarge: TextStyle(
        color: colorGreen,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
          // 2 input text color
          color: colorGreen,
          fontWeight: FontWeight.w800),
      headlineLarge: TextStyle(
        color: colorGreen,
        fontWeight: FontWeight.w800,
        fontSize: 20.0,
      ),
      headlineSmall: TextStyle(
        color: colorGreen,
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
      ),
      headlineMedium: TextStyle(
        // 2-
        color: colorWhite,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      ),
      titleMedium: TextStyle(color: colorGreen)),
  appBarTheme: const AppBarTheme(
    // elevation: 0,
    // color: Color.fromARGB(255, 55, 55, 55),
    color: colorGreen,

    foregroundColor: iconGreenColor,
    // titleTextStyle: TextStyle(
    //   // color: textColor,
    //   // fontSize: 14,
    //   // fontWeight: FontWeight.w800,
    // ),
  ),
  primarySwatch: Colors.green,
  // primaryIconTheme: const IconThemeData(color: Color.fromARGB(255, 182, 137, 2)),
  //  iconTheme: const IconThemeData(color: Colors.blue),
  listTileTheme: const ListTileThemeData(
    iconColor: iconGreenColor,
    selectedColor: colorWhite,
    // tileColor: Colors.amber,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: formFildColor,
    focusColor: formFildColor,
    labelStyle: TextStyle(
      color: iconGreenColor,
      fontSize: 16,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: iconGreenColor,
      ),
    ),
    suffixIconColor: iconGreenColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: elevatedButtonTheme,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonGreenStyle),
  cardTheme: const CardTheme(
    color: formFildColor,
    shadowColor: coloR0xFFB2BABB,
    elevation: 4.0,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(12.0),
    // ),
    
    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 5, bottom: 5),
    surfaceTintColor: Color(0xFFF7F7F7),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: colorGreen,
    contentTextStyle: TextStyle(color: colorWhite),
    titleTextStyle: TextStyle(
      color: colorWhite,
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
    ),
    shadowColor: Color(0xFFFFFFFF),
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)))
    // shape:BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(30.0, 15.0)))
    // this.contentTextStyle,
  ),
  // hintColor: Colors.yellow,
  // hoverColor: Colors.blue
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    indicatorColor: colorWhite,
    dividerHeight: BorderSide.strokeAlignCenter,
    labelColor: colorWhite,
    overlayColor: MaterialStatePropertyAll(iconGreenColor),
    unselectedLabelColor: Color.fromARGB(255, 25, 163, 136),
    // dividerColor: Colors.blueAccent
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    // backgroundColor: Color.fromARGB(255,251,189,4),
    backgroundColor: colorWhite,
  ),
  textButtonTheme: TextButtonThemeData(style: textButtnStyleGrean),
);
