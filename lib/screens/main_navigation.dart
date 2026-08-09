// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../home_screen.dart'; // Kyunki ab home_screen ek folder bahar hai
import 'festival_calendar_screen.dart'; // Yahan naam theek kiya
import 'map_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // 🛠️ Yahan order theek kiya hai taaki tabs (Home -> Map -> Festivals) se match kare
  final List<Widget> _pages = [
    const HomeScreen(),
    const MapScreen(),               // Explore tab ke liye Map
    const FestivalCalendarScreen(),  // Festivals tab ke liye Calendar
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🛠️ Yahan '_screens' ki jagah '_pages' aayega!
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppTheme.accentGold, // Golden for active tab
        unselectedItemColor: AppTheme.textMuted, // Muted grey for inactive
        backgroundColor: AppTheme.surfaceDark, // Dark background
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Festivals'),
        ],
      ),
    );
  }
}