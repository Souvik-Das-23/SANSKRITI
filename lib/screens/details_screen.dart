// lib/screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models/heritage_place.dart';
import '../services/favorites_service.dart';
import '../services/location_service.dart';
import '../widgets/audio_guide_bottom_sheet.dart';
import 'ticket_booking_screen.dart';

class DetailsScreen extends StatefulWidget {
  final HeritagePlace place;

  const DetailsScreen({super.key, required this.place});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesService _favService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final isFav = _favService.isPlaceFavorite(place.id);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 320.0,
              pinned: true,
              backgroundColor: AppTheme.backgroundDark,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(Icons.arrow_back, color: AppTheme.accentGold, size: 20),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppTheme.crimsonRed : AppTheme.accentGold,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _favService.togglePlaceFavorite(place);
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      place.heroImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.surfaceDark,
                        child: const Icon(Icons.account_balance, color: AppTheme.accentGold, size: 60),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.heroOverlayGradient,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (place.isUnescoSite)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.accentGold, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.stars, color: AppTheme.accentGoldShimmer, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    'UNESCO WORLD HERITAGE SITE',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.accentGoldLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Text(
                            place.name,
                            style: GoogleFonts.marcellus(
                              color: AppTheme.accentGoldLight,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            place.hindiName,
                            style: GoogleFonts.rozhaOne(
                              color: AppTheme.accentGold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppTheme.accentGold, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  place.location,
                                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
                                ),
                              ),
                              if (place.liveDistance != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    place.liveDistance!,
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.accentGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.accentGold,
                  indicatorWeight: 3,
                  labelColor: AppTheme.accentGold,
                  unselectedLabelColor: AppTheme.textMuted,
                  labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Architecture'),
                    Tab(text: 'Gallery'),
                    Tab(text: 'Travel Info'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Overview
            _buildOverviewTab(place),
            // Tab 2: Architecture
            _buildArchitectureTab(place),
            // Tab 3: Gallery
            _buildGalleryTab(place),
            // Tab 4: Travel Info
            _buildTravelInfoTab(place),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyBottomBar(context, place),
    );
  }

  Widget _buildOverviewTab(HeritagePlace place) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat grid chips
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Built Era', place.builtCentury, Icons.history_edu),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Dynasty / Patron', place.dynastyOrPatron, Icons.castle),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Timings', place.timings, Icons.access_time),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Entry Fee', place.entryFee, Icons.confirmation_number_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Audio Guide Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.darkCardGradient,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.goldGradient,
                  ),
                  child: const Icon(Icons.headphones, color: AppTheme.backgroundDark, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AUDIO TOUR GUIDE',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        place.audioGuideTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.marcellus(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textLight,
                        ),
                      ),
                      Text(
                        'Duration: ${place.audioGuideDuration} • Multiple Languages',
                        style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => AudioGuideBottomSheet.show(context, place),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(60, 34),
                  ),
                  child: const Text('Listen'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Narrative
          Text(
            'About the Heritage Site',
            style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
          const SizedBox(height: 10),
          Text(
            place.description,
            style: GoogleFonts.outfit(fontSize: 14, height: 1.6, color: AppTheme.textLight),
          ),
          const SizedBox(height: 20),

          // Historical Background
          Text(
            'Historical Chronicle',
            style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
          const SizedBox(height: 10),
          Text(
            place.history,
            style: GoogleFonts.outfit(fontSize: 14, height: 1.6, color: AppTheme.textLight),
          ),
          const SizedBox(height: 24),

          // Cultural Significance
          Text(
            'Cultural & Spiritual Significance',
            style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
          const SizedBox(height: 10),
          ...place.culturalSignificance.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚜️ ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.outfit(fontSize: 13, height: 1.4, color: AppTheme.textLight),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildArchitectureTab(HeritagePlace place) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Architectural Marvels & Engineering',
            style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover the intricate masonry, mathematical alignment, and craftsmanship that define this monumental structure.',
            style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 18),
          ...place.architectureHighlights.asMap().entries.map((entry) {
            int index = entry.key + 1;
            String highlight = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentGold),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: GoogleFonts.cinzel(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      highlight,
                      style: GoogleFonts.outfit(fontSize: 13.5, height: 1.5, color: AppTheme.textLight),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGalleryTab(HeritagePlace place) {
    final allImages = [place.heroImage, ...place.galleryImages];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: allImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(allImages[index], fit: BoxFit.contain),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  allImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppTheme.surfaceDark,
                    child: const Icon(Icons.image, color: AppTheme.textMuted),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTravelInfoTab(HeritagePlace place) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection('🌟 Best Season to Visit', place.bestTimeToVisit),
          const SizedBox(height: 16),
          _buildInfoSection('🎟️ Pass & Entry Information', place.entryFee),
          const SizedBox(height: 16),
          _buildInfoSection('⏰ Opening Hours', place.timings),
          const SizedBox(height: 20),
          Text(
            'Nearby Attractions & Heritage Sites',
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
          const SizedBox(height: 10),
          ...place.nearbyAttractions.map((attraction) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(Icons.explore, color: AppTheme.accentGold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(attraction, style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.accentGold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(content, style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentGold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textMuted)),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, HeritagePlace place) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.3))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Navigate Button
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () => LocationService.launchNavigation(place.lat, place.lng, placeName: place.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.backgroundDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.navigation, size: 18),
                label: const Text('NAVIGATE'),
              ),
            ),
            const SizedBox(width: 10),
            // Book Pass Button
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketBookingScreen(preSelectedPlace: place)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cardDarkElevated,
                  foregroundColor: AppTheme.accentGold,
                  side: const BorderSide(color: AppTheme.accentGold, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                label: const Text('BOOK PASS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.backgroundDark,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
