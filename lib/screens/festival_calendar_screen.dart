import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/festival_repository.dart';
import '../models/festival.dart';
import '../services/favorites_service.dart';

class FestivalCalendarScreen extends StatefulWidget {
  const FestivalCalendarScreen({super.key});

  @override
  State<FestivalCalendarScreen> createState() => _FestivalCalendarScreenState();
}

class _FestivalCalendarScreenState extends State<FestivalCalendarScreen> {
  String _selectedRegion = 'All';
  List<Festival> _festivals = [];
  final FavoritesService _favService = FavoritesService();

  final List<String> _regions = ['All', 'East', 'North', 'South', 'West', 'Central'];

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  void _loadFestivals() {
    setState(() {
      _festivals = FestivalRepository.getFestivalsByRegion(_selectedRegion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('FESTIVAL CALENDAR 2026'),
      ),
      body: Column(
        children: [
          // Region Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _regions.map((region) {
                  bool isSelected = _selectedRegion == region;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                        _loadFestivals();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppTheme.goldGradient : null,
                        color: isSelected ? null : AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        region,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Festival Cards List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              physics: const BouncingScrollPhysics(),
              itemCount: _festivals.length,
              itemBuilder: (context, index) {
                final fest = _festivals[index];
                final isReminded = _favService.isFestivalReminded(fest.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    gradient: AppTheme.glassCardGradient,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Image with overlay
                        SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                fest.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.cardDark),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: AppTheme.heroOverlayGradient,
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    '${fest.region} • ${fest.state}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGoldLight,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _favService.toggleFestivalReminder(fest);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isReminded
                                              ? 'Reminder removed for ${fest.name}'
                                              : 'Festival alert set for ${fest.name} (${fest.dates})!',
                                          style: GoogleFonts.outfit(),
                                        ),
                                        backgroundColor: AppTheme.surfaceDark,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isReminded ? AppTheme.accentGold : Colors.black.withValues(alpha: 0.6),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.accentGold),
                                    ),
                                    child: Icon(
                                      isReminded ? Icons.notifications_active : Icons.notifications_none,
                                      color: isReminded ? AppTheme.backgroundDark : AppTheme.accentGold,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 16,
                                right: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fest.name,
                                      style: GoogleFonts.marcellus(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentGoldLight,
                                      ),
                                    ),
                                    Text(
                                      fest.hindiName,
                                      style: GoogleFonts.rozhaOne(
                                        fontSize: 14,
                                        color: AppTheme.accentGold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Body details
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date Pill
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: AppTheme.accentGold, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    fest.dates,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGoldLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Duration: ${fest.duration}',
                                    style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                fest.significance,
                                style: GoogleFonts.outfit(fontSize: 13, height: 1.45, color: AppTheme.textLight),
                              ),
                              const SizedBox(height: 12),

                              // Festive Delicacies (Bhog)
                              Text(
                                'Festive Delicacies & Bhog:',
                                style: GoogleFonts.cinzel(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: fest.culinarySpecialties.map((dish) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    '🍲 $dish',
                                    style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textLight),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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