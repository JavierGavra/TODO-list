import 'package:flutter/material.dart';
import 'package:todo_list/common/color_app.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context) {
    const Color primaryColor = ColorApp.primary;
    final Map<int, Color> primaryColorMap = {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
    final MaterialColor primaryMaterialColor =
        MaterialColor(primaryColor.value, primaryColorMap);

    return ThemeData(
      // useMaterial3: true,
      primaryColor: ColorApp.primary,
      primarySwatch: primaryMaterialColor,
      accentColor: ColorApp.accent2,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColorApp.accent1,
      iconTheme: const IconThemeData(color: ColorApp.accent1),
      appBarTheme: const AppBarTheme(backgroundColor: ColorApp.primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorApp.accent2,
          foregroundColor: ColorApp.secondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ColorApp.primary),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        headline2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        headline3: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        headline4: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorApp.accent1,
        ),
        headline5: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: ColorApp.accent1,
        ),
      ),
    );
  }
}
