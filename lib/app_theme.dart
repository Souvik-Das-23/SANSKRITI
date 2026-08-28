// lib/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌟 Ultra-Aesthetic Modern Royal Palette 🌟
  static const Color backgroundDark = Color(0xFF09090D); // Deep Obsidian Velvet
  static const Color surfaceDark = Color(0xFF12121A); // Sleek Surface Dark
  static const Color cardDark = Color(0xFF181824); // Glassmorphic Card Base
  static const Color cardDarkElevated = Color(0xFF202030); // Elevated Card
  static const Color surfaceGlass = Color(0xCC151522); // Frosted Glass Surface

  // Imperial Gold Spectrum
  static const Color accentGold = Color(0xFFD4AF37); // Royal Antique Gold
  static const Color accentGoldLight = Color(0xFFF9ECD2); // Champagne Cream
  static const Color accentGoldShimmer = Color(0xFFFFDF73); // Radiant Shimmer Gold
  static const Color accentGoldDark = Color(0xFF9E782F); // Rich Bronze Gold
  static const Color amberWarm = Color(0xFFFFB300); // Warm Sunset Amber

  // Contrast Accents
  static const Color textLight = Color(0xFFFBFBFE); // Pure Soft White
  static const Color textMuted = Color(0xFF9E9EB2); // Modern Slate Grey
  static const Color textSecondary = Color(0xFFD4D4E8);
  static const Color crimsonRed = Color(0xFFE74C3C); // Royal Crimson
  static const Color emeraldGreen = Color(0xFF2ECC71); // Emerald Jade
  static const Color sapphireBlue = Color(0xFF3498DB); // Royal Indigo
  static const Color terracotta = Color(0xFFE06D53); // Indian Terracotta

  // 🌟 Signature Gradients 🌟
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFEA9F), Color(0xFFD4AF37), Color(0xFFA67C1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldShimmerGradient = LinearGradient(
    colors: [Color(0xFFFFF6D6), Color(0xFFFFDF73), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E1E2C), Color(0xFF13131D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [Color(0xEE222234), Color(0xDD141420)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [Colors.transparent, Color(0x8009090D), Color(0xF509090D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.25, 0.65, 1.0],
  );

  // Modern Box Decorations
  static BoxDecoration modernCardDecoration({
    double borderRadius = 22.0,
    bool isSelected = false,
    bool hasGlow = false,
  }) {
    return BoxDecoration(
      gradient: glassCardGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isSelected
            ? accentGold
            : accentGold.withValues(alpha: isSelected ? 0.8 : 0.22),
        width: isSelected ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: hasGlow || isSelected
              ? accentGold.withValues(alpha: 0.18)
              : Colors.black.withValues(alpha: 0.5),
          blurRadius: isSelected ? 16 : 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration glassmorphicPillDecoration({bool isSelected = false}) {
    return BoxDecoration(
      gradient: isSelected ? goldGradient : null,
      color: isSelected ? null : surfaceDark.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: isSelected ? accentGold : accentGold.withValues(alpha: 0.25),
        width: 1.0,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: accentGold.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
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
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: accentGoldLight,
          letterSpacing: 1.4,
        ),
        displayMedium: GoogleFonts.cinzel(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: accentGoldLight,
        ),
        titleLarge: GoogleFonts.marcellus(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textLight,
          letterSpacing: 0.5,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 17,
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
          color: accentGoldLight,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: backgroundDark,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}