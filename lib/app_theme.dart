// lib/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Royal Indian Dark & Golden Palette
  static const Color backgroundDark = Color(0xFF121212); // Deep Charcoal/Night
  static const Color surfaceDark = Color(0xFF1E1E1E); // Elevated Dark for cards
  static const Color accentGold = Color(0xFFD4AF37); // Royal Antique Gold
  static const Color textLight = Color(0xFFFDFBF7); // Soft Ivory for text
  static const Color textMuted = Color(0xFFAAAAAA); // Muted grey for subtitles

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentGold,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentGold,
        surface: surfaceDark,
      ),
      // Classic Serif headings, Modern Sans-Serif body
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: accentGold, // Golden Headings
          fontFamily: 'Serif',
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textLight,
          fontFamily: 'Serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        iconTheme: IconThemeData(color: accentGold),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: accentGold,
          fontFamily: 'Serif',
        ),
      ),
    );
  }
}