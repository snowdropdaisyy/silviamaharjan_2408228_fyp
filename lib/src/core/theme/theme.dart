// lib/src/core/theme/theme.dart
import 'package:flutter/material.dart';

const appColors = AppColors.standard;

class AppColors {
  final Color background;
  final Color button;
  final Color textPrimary;
  final Color buttonText;
  final Color inputFieldBorder;
  final Color heading;
  final Color error;

  const AppColors({
    required this.background,
    required this.button,
    required this.textPrimary,
    required this.buttonText,
    required this.inputFieldBorder,
    required this.heading,
    required this.error,
  });

  static const AppColors standard = AppColors(
    background: Color(0xFFFFFBFB),
    button: Color(0xFFD85C7B),
    textPrimary: Color(0xFF76525D),
    buttonText: Color(0xFFFFFFFF),
    inputFieldBorder: Color(0xFFD9CACE),
    heading: Color(0xFFD85C7B),
    error: Color(0xFFCF5D60),
  );
}

// Define ThemeData using your colors
final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: appColors.background,
  primaryColor: appColors.button,
  colorScheme: ColorScheme.fromSeed(
    seedColor: appColors.button,
    background: appColors.background,
    primary: appColors.button,
    onPrimary: appColors.buttonText,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColors.button,
      foregroundColor: appColors.buttonText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
    ),
  ),
);