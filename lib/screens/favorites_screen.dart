// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/festival_repository.dart';
import '../data/heritage_repository.dart';
import '../services/favorites_service.dart';
import '../widgets/heritage_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesService _favService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _favService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _favService.removeListener(_onUpdate);
    _tabController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = HeritageRepository.getAllPlaces();
    final favPlaces = allPlaces.where((p) => _favService.isPlaceFavorite(p.id)).toList();

    final allFestivals = FestivalRepository.getAllFestivals();
    final savedFestivals = allFestivals.where((f) => _favService.isFestivalSaved(f.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Saved Treasures'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentGold,
          labelColor: AppTheme.accentGold,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: [
            Tab(text: 'Monuments (${favPlaces.length})'),
            Tab(text: 'Festivals (${savedFestivals.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Saved Monuments Tab
          favPlaces.isEmpty
              ? _buildEmptyState('No saved monuments yet', 'Tap the heart icon on any monument card to save it to your royal itinerary.')
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: favPlaces.length,
                  itemBuilder: (context, index) {
                    return HeritageCard(place: favPlaces[index], onFavoriteChanged: () => setState(() {}));
                  },
                ),

          // 2. Saved Festivals Tab
          savedFestivals.isEmpty
              ? _buildEmptyState('No festival reminders', 'Browse the Festival Calendar and activate reminders for cultural celebrations.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: savedFestivals.length,
                  itemBuilder: (context, index) {
                    final fest = savedFestivals[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              fest.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fest.name,
                                  style: GoogleFonts.marcellus(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentGoldLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  fest.dates,
                                  style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.accentGold),
                                ),
                                Text(
                                  fest.state,
                                  style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_active, color: AppTheme.accentGold),
                            onPressed: () {
                              _favService.toggleFestivalSaved(fest);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cardDark,
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.bookmark_border, color: AppTheme.accentGold, size: 40),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGoldLight),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
