// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Timer ke liye
import '../app_theme.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Fade-in Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // 3 seconds baad automatically Home Screen par le jayega
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark, // Deep Charcoal background
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Golden Royal Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentGold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.account_balance, // Heritage/Temple icon
                  size: 80,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 30),
              
              // App Name
              Text(
                'Sanskriti',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 40,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              
              // Tagline
              Text(
                'Discover India\'s Heritage',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentGold.withValues(alpha: 0.7),
                  letterSpacing: 1.5,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}