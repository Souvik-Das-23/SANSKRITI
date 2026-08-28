// lib/screens/festival_calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/festival_repository.dart';
import '../services/favorites_service.dart';

class FestivalCalendarScreen extends StatefulWidget {
  const FestivalCalendarScreen({super.key});

  @override
  State<FestivalCalendarScreen> createState() => _FestivalCalendarScreenState();
}

class _FestivalCalendarScreenState extends State<FestivalCalendarScreen> {
  String _selectedRegion = 'All';
  final FavoritesService _favService = FavoritesService();

  final List<String> _regions = [
    'All',
    'East India',
    'South India',
    'West India',
    'Pan India',
  ];

  @override
  Widget build(BuildContext context) {
    final festivals = FestivalRepository.getFestivalsByRegion(_selectedRegion);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Indian Festival Calendar 2026'),
      ),
      body: Column(
        children: [
          // Region Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _regions.map((region) {
                  bool isSel = _selectedRegion == region;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRegion = region),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: isSel ? AppTheme.goldGradient : null,
                        color: isSel ? null : AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSel ? AppTheme.accentGold : Colors.white12),
                      ),
                      child: Text(
                        region,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel ? AppTheme.backgroundDark : AppTheme.textLight,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // List of Festivals
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: festivals.length,
              itemBuilder: (context, index) {
                final festival = festivals[index];
                final isSaved = _favService.isFestivalSaved(festival.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Festival Hero Image with Dates Pill
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                            child: Image.network(
                              festival.image,
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 190,
                                color: AppTheme.surfaceDark,
                                child: const Icon(Icons.celebration, color: AppTheme.accentGold, size: 48),
                              ),
                            ),
                          ),
                          Container(
                            height: 190,
                            decoration: const BoxDecoration(
                              gradient: AppTheme.heroOverlayGradient,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.6)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: AppTheme.accentGold, size: 12),
                                  const SizedBox(width: 6),
                                  Text(
                                    festival.dates,
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.accentGoldLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                festival.duration,
                                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 14,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  festival.name,
                                  style: GoogleFonts.marcellus(
                                    color: AppTheme.accentGoldLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  festival.hindiName,
                                  style: GoogleFonts.rozhaOne(
                                    color: AppTheme.accentGold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Festival Content Body
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: AppTheme.accentGold, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    festival.state,
                                    style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              festival.significance,
                              style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 14),

                            // Rituals
                            Text(
                              'Rituals & Traditions:',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...festival.rituals.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('🪔 ', style: TextStyle(fontSize: 12)),
                                  Expanded(
                                    child: Text(
                                      r,
                                      style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(height: 14),

                            // Culinary Delicacies
                            Text(
                              'Festive Delicacies & Prasad:',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: festival.culinarySpecialties.map((food) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceDark,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Text(
                                  '🍲 $food',
                                  style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textLight),
                                ),
                              )).toList(),
                            ),
                            const SizedBox(height: 16),

                            // Reminder Action Button
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _favService.toggleFestivalSaved(festival);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isSaved
                                          ? 'Removed reminder for ${festival.name}'
                                          : 'Reminder set for ${festival.name} (${festival.dates})!',
                                    ),
                                    backgroundColor: AppTheme.accentGold,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSaved ? AppTheme.cardDarkElevated : AppTheme.accentGold,
                                foregroundColor: isSaved ? AppTheme.accentGold : AppTheme.backgroundDark,
                                side: isSaved ? const BorderSide(color: AppTheme.accentGold) : null,
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              icon: Icon(isSaved ? Icons.notifications_active : Icons.notifications_none, size: 18),
                              label: Text(
                                isSaved ? 'REMINDER ACTIVE' : 'SET FESTIVAL REMINDER',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}