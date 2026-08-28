// lib/screens/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    _navTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => const MainNavigation(),
            transitionsBuilder: (context, anim1, anim2, child) {
              return FadeTransition(opacity: anim1, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle radial ambient background glow
          Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentGold.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Royal Golden Medallion Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.darkCardGradient,
                        border: Border.all(color: AppTheme.accentGold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGold.withValues(alpha: 0.3),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        size: 70,
                        color: AppTheme.accentGold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sanskrit Title Shloka
                    Text(
                      '॥ वसुधैव कुटुम्बकम् ॥',
                      style: GoogleFonts.rozhaOne(
                        fontSize: 16,
                        color: AppTheme.accentGold.withValues(alpha: 0.8),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // App Name
                    Text(
                      'Sanskriti',
                      style: GoogleFonts.cinzel(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGoldLight,
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      'Discover India\'s Rich Heritage',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Subtle Golden Loader
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Footer
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'A Digital Cultural Tourism Platform',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: AppTheme.accentGoldDark,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}