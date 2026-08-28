// lib/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌟 Royal Heritage Color Palette 🌟
  static const Color backgroundDark = Color(0xFF0C0C10); // Deep Obsidian
  static const Color surfaceDark = Color(0xFF14141C); // Elevated Surface
  static const Color cardDark = Color(0xFF1B1B26); // Card Background
  static const Color cardDarkElevated = Color(0xFF222232); // High-contrast Card

  // Gold Spectrum
  static const Color accentGold = Color(0xFFD4AF37); // Royal Gold
  static const Color accentGoldLight = Color(0xFFF5E6C8); // Champagne Cream
  static const Color accentGoldShimmer = Color(0xFFFFDF73); // Glowing Gold
  static const Color accentGoldDark = Color(0xFF996515); // Burnished Bronze

  // Accents
  static const Color textLight = Color(0xFFFDFBF7); // Soft Ivory
  static const Color textMuted = Color(0xFFA6A6B8); // Muted Silver
  static const Color textSecondary = Color(0xFFD0D0E0);
  static const Color crimsonRed = Color(0xFFC0392B); // Royal Crimson
  static const Color emeraldGreen = Color(0xFF27AE60); // Emerald
  static const Color sapphireBlue = Color(0xFF2980B9); // Royal Indigo

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFE899), Color(0xFFD4AF37), Color(0xFF996515)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1F1F2C), Color(0xFF12121A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black45, Color(0xF2000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.3, 0.7, 1.0],
  );

  // Box Decorations
  static BoxDecoration royalCardDecoration({double borderRadius = 20.0, bool isSelected = false}) {
    return BoxDecoration(
      gradient: darkCardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected ? accentGold : accentGold.withValues(alpha: 0.25),
        width: isSelected ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: isSelected ? accentGold.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.4),
          blurRadius: isSelected ? 14 : 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accentGold,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentGoldShimmer,
        surface: surfaceDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: accentGold,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.cinzel(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: accentGold,
        ),
        titleLarge: GoogleFonts.marcellus(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textLight,
          letterSpacing: 0.5,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15,
          color: textLight,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 13,
          color: textMuted,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: accentGold),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: accentGold,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: backgroundDark,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}