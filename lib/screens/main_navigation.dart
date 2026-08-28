// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../widgets/sos_dialog.dart';
import 'ai_assistant_screen.dart';
import 'home_screen.dart';
import 'kala_bazaar_screen.dart';
import 'map_screen.dart';
import 'services_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    MapScreen(),
    ServicesScreen(),
    KalaBazaarScreen(),
    AiAssistantScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Emergency Floating Beacon Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => SosDialog.show(context),
        backgroundColor: AppTheme.crimsonRed,
        elevation: 10,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 2),
        ),
        child: const Icon(Icons.emergency_share, color: Colors.white, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

      // Royal Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          border: Border(
            top: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.3), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppTheme.accentGold,
          unselectedItemColor: AppTheme.textMuted,
          backgroundColor: AppTheme.surfaceDark,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_outlined),
              activeIcon: Icon(Icons.radar),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Bazaar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'Veda AI',
            ),
          ],
        ),
      ),
    );
  }
}