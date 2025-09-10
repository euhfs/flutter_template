import 'package:flutter/material.dart';

/*
  CustomColors ThemeExtension

  This class defines additional theme-aware colors used throughout the app
  that go beyond the main color palette (e.g., success, warning, error, accent).

  How to add a new custom color:
  1. Add a new final Color field to the class, e.g.:
       final Color myNewColor;
       
  2. Add it to the constructor with `required this.myNewColor,`
  
  3. Define the color values for light and dark themes inside the static
     `light` and `dark` constants, e.g.:
       myNewColor: Color(0xFF123456), // light theme value

  4. Add the field to the copyWith method parameters and implementation.

  5. Add the field to the lerp method for smooth color transitions.

  Example - adding "buttonBackground" color:

  // 1. Add field
  final Color buttonBackground;

  // 2. Add to constructor
  const CustomColors({
    required this.buttonBackground,
    // other fields...
  });

  // 3. Define colors for light and dark themes
  static const light = CustomColors(
    buttonBackground: Color(0xFFE0E0E0),
    // other colors...
  );

  static const dark = CustomColors(
    buttonBackground: Color(0xFF303030),
    // other colors...
  );

  // 4. Add to copyWith
  CustomColors copyWith({
    Color? buttonBackground,
    // other params...
  }) {
    return CustomColors(
      buttonBackground: buttonBackground ?? this.buttonBackground,
      // other fields...
    );
  }

  // 5. Add to lerp
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      // other fields...
    );
  }

  Usage in widgets:
  
  final colors = Theme.of(context).extension<CustomColors>()!;
  Container(color: colors.buttonBackground);
*/

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  // Colors for various UI elements used beyond the main color palette
  final Color success; // For success messages and icons
  final Color warning; // For warnings, alerts
  final Color error; // For errors, alerts
  final Color info; // For informational messages or highlights
  final Color accent; // Accent color for buttons and highlights
  final Color cardBackground; // Background color for cards or panels

  // Constructor requiring all colors, ensures immutability and completeness
  const CustomColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.accent,
    required this.cardBackground,
  });

  // Predefined custom colors for light theme
  static const light = CustomColors(
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFA000),
    error: Color(0xFFD32F2F),
    info: Color(0xFF1976D2),
    accent: Color(0xFF00BCD4),
    cardBackground: Color(0xFFF5F5F5),
  );

  // Predefined custom colors for dark theme
  static const dark = CustomColors(
    success: Color(0xFF81C784),
    warning: Color(0xFFFFC947),
    error: Color(0xFFEF5350),
    info: Color(0xFF64B5F6),
    accent: Color(0xFF26C6DA),
    cardBackground: Color(0xFF1E1E1E),
  );

  // Allows copying an instance with optional overrides for specific colors
  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? accent,
    Color? cardBackground,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      accent: accent ?? this.accent,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  // Enables smooth color transitions between light and dark themes
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );
  }
}
