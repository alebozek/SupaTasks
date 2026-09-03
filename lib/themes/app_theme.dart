import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF4B8F8C),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF484D6D),
      brightness: Brightness.dark,
      primary: const Color(0xFF2C365E),
      secondary: const Color(0xFF484D6D),
      surface: const Color(0xFF171A1F),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1115),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF171A1F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF1B1E25),
      textStyle: TextStyle(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF484D6D),
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1B1E25),
      hintStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Color(0xFF8FB3C8), width: 2),
      ),
    ),
  );
}
