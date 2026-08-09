// lib/main.dart
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/splash_screen.dart'; 

void main() {
  runApp(const SanskritiApp());
}

class SanskritiApp extends StatelessWidget {
  const SanskritiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanskriti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, 
      // 👇 WARNING IS WAJAH SE HAI: Is line ko change karke SplashScreen() karna hai 👇
      home: const SplashScreen(), 
    );
  }
}