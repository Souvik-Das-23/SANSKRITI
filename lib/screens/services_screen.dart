// lib/screens/services_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../widgets/sos_dialog.dart';
import 'ai_assistant_screen.dart';
import 'festival_calendar_screen.dart';
import 'heritage_passport_screen.dart';
import 'kala_bazaar_screen.dart';
import 'parampara_screen.dart';
import 'quiz_screen.dart';
import 'spatial_viewer_screen.dart';
import 'ticket_booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'CULTURAL SERVICES',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Services Ecosystem',
                style: GoogleFonts.cinzel(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGoldLight,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 18),

              // Flagship 1: Parampara (Living Traditions & Intangible Heritage)
              _buildWideBentoCard(
                context,
                title: 'Sanskriti Parampara (Living Traditions)',
                subtitle: '8 Classical dance forms & mudras, ancient martial arts (Kalaripayattu), metallurgy & sacred Vedic shlokas.',
                tag: 'UNESCO INTANGIBLE HERITAGE',
                icon: Icons.theater_comedy,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8E44AD), Color(0xFF5B2C6F)],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParamparaScreen()),
                ),
              ),
              const SizedBox(height: 14),

              // Flagship 2: 3D Spatial & Kaalchakra Time-Travel
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: '3D Spatial & AR',
                      subtitle: 'Rotatable temple wireframes & Kaalchakra Time-Travel',
                      icon: Icons.view_in_ar,
                      gradient: const [Color(0xFF2980B9), Color(0xFF1F618D)],
                      height: 165,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SpatialViewerScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: 'Yatra Passport',
                      subtitle: 'Zone stamps, pilgrim log & Royal Scholar Badges',
                      icon: Icons.card_membership,
                      gradient: const [Color(0xFFD4AF37), Color(0xFFAA8010)],
                      height: 165,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HeritagePassportScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Featured Wide Bento Card: Kala Bazaar
              _buildWideBentoCard(
                context,
                title: 'Kala Bazaar (Artisans & Crafts)',
                subtitle: 'Discover authentic GI-tagged handicrafts direct from rural Indian master craftsmen.',
                tag: 'GI-TAGGED AUTHENTIC',
                icon: Icons.storefront,
                gradient: AppTheme.goldGradient,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KalaBazaarScreen()),
                ),
              ),
              const SizedBox(height: 14),

              // Row: Festivals & Tickets
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: 'Festival Calendar',
                      subtitle: 'Rituals, Delicacies & Reminders',
                      icon: Icons.celebration,
                      gradient: const [Color(0xFFE67E22), Color(0xFFD35400)],
                      height: 155,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FestivalCalendarScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: 'E-Passes & Tickets',
                      subtitle: 'ASI Passes & Digital QR Passes',
                      icon: Icons.confirmation_number_outlined,
                      gradient: const [Color(0xFF27AE60), Color(0xFF1E8449)],
                      height: 155,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TicketBookingScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Row: Veda AI & Quiz
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: 'Veda AI & Lens',
                      subtitle: 'Multilingual scholar & artifact image scanner',
                      icon: Icons.auto_awesome,
                      gradient: const [Color(0xFF8E44AD), Color(0xFF6C3483)],
                      height: 155,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildBentoCard(
                      context,
                      title: 'Heritage Trivia',
                      subtitle: 'Dynastic quiz leagues & certificates',
                      icon: Icons.school,
                      gradient: const [Color(0xFF16A085), Color(0xFF117864)],
                      height: 155,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuizScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // SOS Pilgrim Safety Card
              _buildWideBentoCard(
                context,
                title: 'Off-Grid Pilgrim SOS Beacon',
                subtitle: 'Broadcast emergency GPS coordinates and connect directly with 112 Police & 1363 Tourism Helpline.',
                tag: 'SAFETY & EMERGENCY',
                icon: Icons.shield,
                isEmergency: true,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC0392B), Color(0xFF922B21)],
                ),
                onTap: () => SosDialog.show(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.glassCardGradient,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideBentoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String tag,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    bool isEmergency = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isEmergency
                ? const Color(0xFFE74C3C).withValues(alpha: 0.6)
                : AppTheme.accentGold.withValues(alpha: 0.4),
            width: isEmergency ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isEmergency
                  ? const Color(0xFFC0392B).withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isEmergency
                          ? const Color(0xFFE74C3C).withValues(alpha: 0.2)
                          : AppTheme.accentGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isEmergency
                            ? const Color(0xFFE74C3C).withValues(alpha: 0.5)
                            : AppTheme.accentGold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.outfit(
                        color: isEmergency ? const Color(0xFFFF6B6B) : AppTheme.accentGold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradient,
                boxShadow: [
                  BoxShadow(
                    color: isEmergency
                        ? const Color(0xFFE74C3C).withValues(alpha: 0.5)
                        : AppTheme.accentGold.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isEmergency ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
