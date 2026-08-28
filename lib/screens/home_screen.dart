// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';
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
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _refreshLocationAndDistances();
  }

  void _loadPlaces() {
    var places = HeritageRepository.getAllPlaces();
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
    final spotlightPlace = HeritageRepository.getAllPlaces().first; // Taj Mahal or Hampi

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.accentGold,
          backgroundColor: AppTheme.surfaceDark,
          onRefresh: _refreshLocationAndDistances,
          child: CustomScrollView(
            slivers: [
              // 1. Royal App Bar / Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'नमस्ते ',
                                style: GoogleFonts.rozhaOne(
                                  color: AppTheme.accentGold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '• Welcome to India',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sanskriti',
                            style: GoogleFonts.cinzel(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGoldLight,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.cardDark,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                              ),
                              child: const Icon(Icons.favorite, color: AppTheme.crimsonRed, size: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _loadPlaces(),
                      style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search forts, temples, caves, dynasties...',
                        hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: AppTheme.accentGold, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadPlaces();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Featured Spotlight Card
              if (_searchController.text.isEmpty && _selectedCategory == HeritageCategory.all && _selectedState == 'All')
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'HERITAGE SPOTLIGHT OF THE DAY',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
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
                        _buildSpotlightCard(context, spotlightPlace),
                      ],
                    ),
                  ),
                ),

              // 4. Category Filter Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPLORE BY CATEGORY',
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: isSelected ? AppTheme.goldGradient : null,
                                  color: isSelected ? null : AppTheme.cardDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(category.iconName, style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Text(
                                      category.displayName,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

              // 5. State / Region Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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

              // 6. Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HERITAGE DESTINATIONS (${_displayedPlaces.length})',
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

              // 7. Masonry / 2-Column Staggered Grid
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
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverToBoxAdapter(
                    child: _buildStaggeredMasonryGrid(),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightCard(BuildContext context, HeritagePlace place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(place: place)),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
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
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'MONUMENT OF ETERNAL SPLENDOR',
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundDark,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Text(
                            place.name,
                            style: GoogleFonts.marcellus(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGoldLight,
                            ),
                          ),
                          Text(
                            place.location,
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.goldGradient,
                        ),
                        child: const Icon(Icons.headphones, color: AppTheme.backgroundDark, size: 20),
                      ),
                      onPressed: () => AudioGuideBottomSheet.show(context, place),
                    ),
                  ],
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
