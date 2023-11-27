import 'package:flutter/material.dart';
import 'package:sixteen/utilities/constants.dart';

ThemeData lightTheme({Color color = const Color(0xFF005953)}) => ThemeData(
  fontFamily: Constants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF0605e7),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  canvasColor: Colors.black,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  unselectedWidgetColor: const Color(0xFF3B270C),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(background: const Color(0xFFF3F3F3)).copyWith(error: const Color(0xFFE84D4F)),
);

ThemeData darkTheme({Color color = const Color(0xFF126c61)}) => ThemeData(
  fontFamily: Constants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF2d38b3),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  canvasColor: Colors.white,
  unselectedWidgetColor: const Color(0xFF3B270C),
  colorScheme: ColorScheme.dark(primary: color, secondary: color).copyWith(background: const Color(0xFF343636)).copyWith(error: const Color(0xFFdd3135)),
);
