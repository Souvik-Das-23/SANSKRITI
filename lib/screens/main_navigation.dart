import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
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

  final List<Widget> _screens = const [
    HomeScreen(),
    MapScreen(),
    ServicesScreen(),
    KalaBazaarScreen(),
    AiAssistantScreen(),
  ];

  final List<NavigationTabItem> _tabs = const [
    NavigationTabItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover'),
    NavigationTabItem(icon: Icons.radar_outlined, activeIcon: Icons.radar, label: 'Radar'),
    NavigationTabItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Services'),
    NavigationTabItem(icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: 'Bazaar'),
    NavigationTabItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Veda AI'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildModernFloatingNavBar(),
    );
  }

  Widget _buildModernFloatingNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 68,
      decoration: BoxDecoration(
        color: AppTheme.surfaceGlass,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: AppTheme.accentGold.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isSelected = _currentIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentGold.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected
                        ? Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 0.8)
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? tab.activeIcon : tab.icon,
                        color: isSelected ? AppTheme.accentGoldLight : AppTheme.textMuted,
                        size: isSelected ? 22 : 20,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tab.label,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppTheme.accentGold : AppTheme.textMuted,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavigationTabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}