import 'package:flutter/material.dart';
import 'colors.dart';
import 'custom_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      // Brightness
      brightness: Brightness.light,

      // Background Color
      scaffoldBackgroundColor: AppColors.lightBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightAppBar,
        foregroundColor: AppColors.lightPrimaryText,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.lightBackground),

      // Icon theme
      iconTheme: const IconThemeData(color: AppColors.lightIconColor),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 57, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.lightPrimaryText, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: AppColors.lightPrimaryText, fontSize: 36, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: AppColors.lightPrimaryText, fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: AppColors.lightPrimaryText, fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: AppColors.lightSecondaryText, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.lightSecondaryText, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: AppColors.lightSecondaryText, fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: AppColors.lightSecondaryText, fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: AppColors.lightSecondaryText, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.lightSecondaryText, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: AppColors.lightSecondaryText, fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // Text Selection Theme
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color.fromARGB(255, 255, 111, 15),
        selectionColor: Colors.grey,
        selectionHandleColor: Color.fromARGB(255, 255, 111, 15),
      ),

      // Disable hover and splash effects
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,

      // Custom Colors
      extensions: <ThemeExtension<dynamic>>[
        CustomColors.light, // for light theme
      ],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      // Brightness
      brightness: Brightness.dark,

      // Background Color
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar Theme
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkAppBar, foregroundColor: AppColors.darkPrimaryText),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: AppColors.darkBackground),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.darkIconColor),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 57, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.darkPrimaryText, fontSize: 45, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: AppColors.darkPrimaryText, fontSize: 36, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: AppColors.darkPrimaryText, fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: AppColors.darkPrimaryText, fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: AppColors.darkSecondaryText, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.darkSecondaryText, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: AppColors.darkSecondaryText, fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: AppColors.darkSecondaryText, fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: AppColors.darkSecondaryText, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.darkSecondaryText, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: AppColors.darkSecondaryText, fontSize: 11, fontWeight: FontWeight.w500),
      ),

      // Text Selection Theme
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color.fromARGB(255, 255, 111, 15),
        selectionColor: Colors.grey,
        selectionHandleColor: Color.fromARGB(255, 255, 111, 15),
      ),

      // Disable hover and splash effects
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,

      // Custom Colors
      extensions: <ThemeExtension<dynamic>>[CustomColors.dark],
    );
  }
}
