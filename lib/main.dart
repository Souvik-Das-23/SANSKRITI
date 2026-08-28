// lib/main.dart
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SanskritiApp());
}

class SanskritiApp extends StatelessWidget {
  const SanskritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanskriti — Discover India\'s Rich Heritage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}