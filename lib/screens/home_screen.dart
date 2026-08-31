// lib/screens/home_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';
import '../services/favorites_service.dart';
import '../services/location_service.dart';
import '../widgets/audio_guide_bottom_sheet.dart';
import '../widgets/heritage_card.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeritageCategory _selectedCategory = HeritageCategory.all;
  String _selectedState = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<HeritagePlace> _displayedPlaces = [];
  bool _isLoadingLocation = false;
  final FavoritesService _favService = FavoritesService();

  final List<String> _states = [
    'All',
    'West Bengal',
    'Rajasthan',
    'Uttar Pradesh',
    'Karnataka',
    'Maharashtra',
    'Tamil Nadu',
    'Odisha',
    'Madhya Pradesh',
    'Delhi',
    'Gujarat',
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _refreshLocationAndDistances();
  }

  void _loadPlaces() {
    var places = List<HeritagePlace>.from(HeritageRepository.getAllPlaces());
    if (_selectedCategory != HeritageCategory.all) {
      places = places.where((p) => p.category == _selectedCategory).toList();
    }
    if (_selectedState != 'All') {
      places = places.where((p) => p.state == _selectedState).toList();
    }
    if (_searchController.text.trim().isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      places = places.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.hindiName.contains(q) ||
        p.location.toLowerCase().contains(q) ||
        p.dynastyOrPatron.toLowerCase().contains(q)
      ).toList();
    }
    setState(() {
      _displayedPlaces = places;
    });
  }

  Future<void> _refreshLocationAndDistances() async {
    setState(() => _isLoadingLocation = true);
    final userPos = await LocationService.getCurrentLocation();
    final allPlaces = HeritageRepository.getAllPlaces();
    LocationService.updatePlacesDistances(allPlaces, userPos);
    setState(() {
      _isLoadingLocation = false;
      _loadPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = HeritageRepository.getAllPlaces();
    final spotlightPlace = allPlaces.first; // Taj Mahal

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accentGold,
          backgroundColor: AppTheme.surfaceDark,
          onRefresh: _refreshLocationAndDistances,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Ultra-Aesthetic Top Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.accentGold,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accentGold,
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'EXPLORING INDIA',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentGoldLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sanskriti',
                            style: GoogleFonts.cinzel(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGoldLight,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      // Saved bookmarks button with badge
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppTheme.glassCardGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.accentGold.withValues(alpha: 0.35),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.bookmark_outline, color: AppTheme.accentGold, size: 20),
                              if (_favService.favoritePlaceIds.isNotEmpty)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.crimsonRed,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                    child: Center(
                                      child: Text(
                                        '${_favService.favoritePlaceIds.length}',
                                        style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Modern Glassmorphic Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.glassCardGradient,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.accentGold.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _loadPlaces(),
                      style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search monuments, temples, dynasties...',
                        hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: AppTheme.accentGold, size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadPlaces();
                                },
                              )
                            : Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceDark,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                                ),
                                child: const Icon(Icons.tune, color: AppTheme.accentGold, size: 16),
                              ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Heritage Stories Horizon Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    height: 96,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: allPlaces.take(6).length,
                      itemBuilder: (context, index) {
                        final place = allPlaces[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailsScreen(place: place)),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppTheme.goldGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentGold.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(place.heroImage),
                                    backgroundColor: AppTheme.surfaceDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 68,
                                  child: Text(
                                    place.name.split(' ')[0],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.accentGoldLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 4. Spotlight of the Day Card
              if (_searchController.text.isEmpty && _selectedCategory == HeritageCategory.all && _selectedState == 'All')
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SPOTLIGHT OF THE WEEK',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                'Featured',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGoldLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildSpotlightHeroCard(context, spotlightPlace),
                      ],
                    ),
                  ),
                ),

              // 5. Category Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPLORE HERITAGE',
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: HeritageCategory.values.map((category) {
                            bool isSelected = _selectedCategory == category;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                  _loadPlaces();
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  gradient: isSelected ? AppTheme.goldGradient : null,
                                  color: isSelected ? null : AppTheme.cardDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.2),
                                    width: 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppTheme.accentGold.withValues(alpha: 0.25),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(category.iconName, style: const TextStyle(fontSize: 13)),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.displayName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                        color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. State Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _states.map((st) {
                        bool isSelected = _selectedState == st;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedState = st;
                              _loadPlaces();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.accentGold.withValues(alpha: 0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppTheme.accentGold : Colors.white12,
                              ),
                            ),
                            child: Text(
                              st,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppTheme.accentGoldLight : AppTheme.textMuted,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // 7. Results Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DESTINATIONS (${_displayedPlaces.length})',
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      if (_isLoadingLocation)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentGold),
                        ),
                    ],
                  ),
                ),
              ),

              // 8. Staggered Grid
              if (_displayedPlaces.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, size: 48, color: AppTheme.accentGold),
                          const SizedBox(height: 12),
                          Text(
                            'No heritage monuments found matching your criteria.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildStaggeredMasonryGrid(),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightHeroCard(BuildContext context, HeritagePlace place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(place: place)),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.45), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                place.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.cardDark),
              ),
              Container(
                decoration: const BoxDecoration(gradient: AppTheme.heroOverlayGradient),
              ),
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.25), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.stars, color: AppTheme.accentGoldShimmer, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      'UNESCO WORLD HERITAGE',
                                      style: GoogleFonts.outfit(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentGoldLight,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  place.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.marcellus(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentGoldLight,
                                  ),
                                ),
                                Text(
                                  place.location,
                                  style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => AudioGuideBottomSheet.show(context, place),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.goldGradient,
                              ),
                              child: const Icon(Icons.headphones, color: AppTheme.backgroundDark, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaggeredMasonryGrid() {
    List<HeritagePlace> col1 = [];
    List<HeritagePlace> col2 = [];

    for (int i = 0; i < _displayedPlaces.length; i++) {
      if (i % 2 == 0) {
        col1.add(_displayedPlaces[i]);
      } else {
        col2.add(_displayedPlaces[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: col1.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: HeritageCard(place: p, onFavoriteChanged: () => setState(() {})),
            )).toList(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: col2.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: HeritageCard(place: p, onFavoriteChanged: () => setState(() {})),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
