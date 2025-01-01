import 'package:flutter/material.dart';

// Définir une classe contenant toutes vos couleurs
class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkBlue = Color(0xFF2E4052);
  static const Color blueGray = Color(0xFF52676E);
  static const Color lightGray = Color(0xFF768D89);
  static const Color mintGreen = Color(0xFF9AB3A4);
  static const Color lightMint = Color(0xFFBDD9BF);
}

// Définir un thème pour votre application
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.darkBlue,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      foregroundColor: AppColors.white,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: AppColors.darkBlue, fontSize: 16),
      bodyText2: TextStyle(color: AppColors.blueGray, fontSize: 14),
      headline1: TextStyle(
          color: AppColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 24),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.mintGreen,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mintGreen,
        textStyle:
            TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
