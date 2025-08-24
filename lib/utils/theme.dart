import 'package:flutter/material.dart';

// PRIME Brand Colors - Static Class (for direct access)
class PrimeColors {
  // Primary Colors
  static const Color primaryRed = Color(0xFFB50612); // #b50612
  static const Color pureBlack = Color(0xFF000000); // #000000
  static const Color pureWhite = Color(0xFFFFFFFF); // #FFFFFF
  static const Color successGreen = Color(0xFF008000); // #008000

  // Secondary Colors - Grayscale/Neutral
  static const Color lightGray = Color(0xFFB2B2B2); // #B2B2B2

  // Secondary Colors - Shades of Red
  static const Color darkRed = Color(0xFF841225); // #841225
  static const Color mediumRed = Color(0xFFD81E46); // #d81e46
  static const Color brightRed = Color(0xFFF74646); // #f74646
}

// PRIME Brand Colors - Mixin (for flexible usage)
mixin PrimeColorsMixin {
  Color get primaryRed => PrimeColors.primaryRed;
  Color get pureBlack => PrimeColors.pureBlack;
  Color get pureWhite => PrimeColors.pureWhite;
  Color get lightGray => PrimeColors.lightGray;
  Color get darkRed => PrimeColors.darkRed;
  Color get mediumRed => PrimeColors.mediumRed;
  Color get brightRed => PrimeColors.brightRed;
}

// PRIME App Theme - Static Class
class PrimeTheme {
  static ThemeData getLightTheme(String fontFamily) {
    return ThemeData(
      primarySwatch: MaterialColor(
        PrimeColors.primaryRed.toARGB32(),
        <int, Color>{
          50: PrimeColors.primaryRed.withValues(alpha: 0.1),
          100: PrimeColors.primaryRed.withValues(alpha: 0.2),
          200: PrimeColors.primaryRed.withValues(alpha: 0.3),
          300: PrimeColors.primaryRed.withValues(alpha: 0.4),
          400: PrimeColors.primaryRed.withValues(alpha: 0.5),
          500: PrimeColors.primaryRed,
          600: PrimeColors.primaryRed.withValues(alpha: 0.7),
          700: PrimeColors.primaryRed.withValues(alpha: 0.8),
          800: PrimeColors.primaryRed.withValues(alpha: 0.9),
          900: PrimeColors.primaryRed,
        },
      ),
      primaryColor: PrimeColors.primaryRed,
      scaffoldBackgroundColor: PrimeColors.pureWhite,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PrimeColors.primaryRed,
        primary: PrimeColors.primaryRed,
        secondary: PrimeColors.pureBlack,
        surface: PrimeColors.pureWhite,
      ),
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: PrimeColors.primaryRed,
        foregroundColor: PrimeColors.pureWhite,
        elevation: 0,
        centerTitle: true,
      ),
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PrimeColors.primaryRed,
          foregroundColor: PrimeColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: PrimeColors.primaryRed,
        ),
      ),
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: PrimeColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: PrimeColors.primaryRed, width: 2),
        ),
        labelStyle: TextStyle(color: PrimeColors.lightGray),
        floatingLabelStyle: TextStyle(color: PrimeColors.primaryRed),
      ),
    );
  }
}

// PRIME App Theme - Mixin (for flexible usage)
mixin PrimeThemeMixin {
  ThemeData getLightTheme(String fontFamily) =>
      PrimeTheme.getLightTheme(fontFamily);

  // Additional theme methods can be added here
  ThemeData getDarkTheme(String fontFamily) {
    // Future dark theme implementation
    return getLightTheme(fontFamily); // For now, return light theme
  }
}
