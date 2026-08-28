// lib/screens/services_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../widgets/audio_guide_bottom_sheet.dart';
import '../widgets/sos_dialog.dart';
import 'ai_assistant_screen.dart';
import 'favorites_screen.dart';
import 'festival_calendar_screen.dart';
import 'kala_bazaar_screen.dart';
import 'quiz_screen.dart';
import 'ticket_booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Cultural Services Hub'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Royal Welcome Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTheme.darkCardGradient,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                    ),
                    child: const Icon(Icons.temple_hindu, color: AppTheme.backgroundDark, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sanskriti Tourism Ecosystem',
                          style: GoogleFonts.marcellus(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGoldLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Explore heritage ticketing, festive calendars, audio tours, authentic crafts, and AI assistance.',
                          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'EXPERIENCES & SERVICES',
              style: GoogleFonts.cinzel(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 14),

            // 2x4 Grid of Services
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.05,
              children: [
                // 1. Festival Calendar
                _buildServiceTile(
                  context,
                  title: 'Festival\nCalendar',
                  subtitle: 'Traditions & Dates',
                  icon: Icons.celebration,
                  badgeText: 'Live 2026',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FestivalCalendarScreen()),
                    );
                  },
                ),

                // 2. Heritage Monument Passes
                _buildServiceTile(
                  context,
                  title: 'Heritage\nTickets & Passes',
                  subtitle: 'Fast-Track Entry',
                  icon: Icons.confirmation_number_outlined,
                  badgeText: 'Instant QR',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TicketBookingScreen()),
                    );
                  },
                ),

                // 3. Kala Bazaar
                _buildServiceTile(
                  context,
                  title: 'Kala\nBazaar',
                  subtitle: 'GI-Tagged Handicrafts',
                  icon: Icons.storefront,
                  badgeText: 'Artisans',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KalaBazaarScreen()),
                    );
                  },
                ),

                // 4. Sanskriti AI / Veda Assistant
                _buildServiceTile(
                  context,
                  title: 'Veda AI\nAssistant',
                  subtitle: 'Heritage Q&A & Trails',
                  icon: Icons.auto_awesome,
                  badgeText: 'Smart Guide',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
                    );
                  },
                ),

                // 5. Audio Guides Portal
                _buildServiceTile(
                  context,
                  title: 'Audio Tour\nGuides',
                  subtitle: 'Narrations & Music',
                  icon: Icons.headphones,
                  badgeText: 'Multi-Lingual',
                  onTap: () {
                    final firstPlace = HeritageRepository.getAllPlaces().first;
                    AudioGuideBottomSheet.show(context, firstPlace);
                  },
                ),

                // 6. Heritage Trivia Quiz
                _buildServiceTile(
                  context,
                  title: 'Heritage\nTrivia Quiz',
                  subtitle: 'Earn Explorer Badges',
                  icon: Icons.quiz,
                  badgeText: 'Interactive',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    );
                  },
                ),

                // 7. Off-Grid SOS
                _buildServiceTile(
                  context,
                  title: 'Off-Grid\nSOS Beacon',
                  subtitle: 'Pilgrim Safety',
                  icon: Icons.emergency_share,
                  badgeText: 'Emergency',
                  isRed: true,
                  onTap: () => SosDialog.show(context),
                ),

                // 8. Saved Favorites
                _buildServiceTile(
                  context,
                  title: 'Saved\nTreasures',
                  subtitle: 'Bookmarks & Alerts',
                  icon: Icons.favorite,
                  badgeText: 'Personal',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    final borderColor = isRed ? AppTheme.crimsonRed : AppTheme.accentGold.withValues(alpha: 0.3);
    final iconColor = isRed ? AppTheme.crimsonRed : AppTheme.accentGold;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isRed ? AppTheme.crimsonRed.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor.withValues(alpha: 0.5)),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRed ? AppTheme.crimsonRed.withValues(alpha: 0.2) : AppTheme.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isRed ? AppTheme.crimsonRed : AppTheme.accentGoldLight,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.marcellus(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
