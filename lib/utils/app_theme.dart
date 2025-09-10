import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightAppBar,
        foregroundColor: AppColors.lightPrimaryText,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightIconColor),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
        bodyMedium: TextStyle(color: AppColors.lightSecondaryText),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.grey,
        selectionHandleColor: Colors.blue,
      ),
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkAppBar,
        foregroundColor: AppColors.darkPrimaryText,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkIconColor),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
        bodyMedium: TextStyle(color: AppColors.darkSecondaryText),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.grey,
        selectionHandleColor: Colors.blue,
      ),
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
    );
  }
}
