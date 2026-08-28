// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';
import '../services/location_service.dart';
import 'details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _userLatlng = LocationService.defaultLocation;
  bool _isLoadingLocation = true;
  HeritageCategory _selectedCategory = HeritageCategory.all;
  double _maxRadiusKm = 1000.0; // Default wide radius
  HeritagePlace? _focusedPlace;

  List<HeritagePlace> _allPlaces = [];
  List<HeritagePlace> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _allPlaces = HeritageRepository.getAllPlaces();
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final pos = await LocationService.getCurrentLocation();
      setState(() {
        _userLatlng = pos;
        LocationService.updatePlacesDistances(_allPlaces, _userLatlng);
        _applyFilters();
        _isLoadingLocation = false;
      });
      _mapController.move(_userLatlng, 10.0);
    } catch (e) {
      LocationService.updatePlacesDistances(_allPlaces, _userLatlng);
      _applyFilters();
      setState(() => _isLoadingLocation = false);
    }
  }

  void _applyFilters() {
    var list = List<HeritagePlace>.from(_allPlaces);
    if (_selectedCategory != HeritageCategory.all) {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_maxRadiusKm < 900.0) {
      list = list.where((p) {
        double dist = LocationService.calculateDistanceInKm(_userLatlng.latitude, _userLatlng.longitude, p.lat, p.lng);
        return dist <= _maxRadiusKm;
      }).toList();
    }
    // Sort by proximity
    list.sort((a, b) {
      double distA = LocationService.calculateDistanceInKm(_userLatlng.latitude, _userLatlng.longitude, a.lat, a.lng);
      double distB = LocationService.calculateDistanceInKm(_userLatlng.latitude, _userLatlng.longitude, b.lat, b.lng);
      return distA.compareTo(distB);
    });

    setState(() {
      _filteredPlaces = list;
      if (_filteredPlaces.isNotEmpty && _focusedPlace == null) {
        _focusedPlace = _filteredPlaces.first;
      }
    });
  }

  void _focusOnPlace(HeritagePlace place) {
    setState(() {
      _focusedPlace = place;
    });
    _mapController.move(LatLng(place.lat, place.lng), 14.0);
  }

  Color _getCategoryMarkerColor(HeritageCategory category) {
    switch (category) {
      case HeritageCategory.temples:
        return AppTheme.accentGold;
      case HeritageCategory.forts:
        return AppTheme.crimsonRed;
      case HeritageCategory.caves:
        return AppTheme.emeraldGreen;
      case HeritageCategory.palaces:
        return AppTheme.sapphireBlue;
      case HeritageCategory.ghats:
        return const Color(0xFF00BCD4);
      default:
        return AppTheme.accentGoldShimmer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // 1. Dark Tile Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLatlng,
              initialZoom: 10.0,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.sanskriti.heritage',
              ),
              MarkerLayer(
                markers: [
                  // User Location Marker
                  Marker(
                    point: _userLatlng,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.lightBlueAccent, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.my_location, color: Colors.cyanAccent, size: 24),
                      ),
                    ),
                  ),
                  // Heritage Places Markers
                  ..._filteredPlaces.map((place) {
                    bool isFocused = _focusedPlace?.id == place.id;
                    Color markerColor = _getCategoryMarkerColor(place.category);

                    return Marker(
                      point: LatLng(place.lat, place.lng),
                      width: isFocused ? 55 : 44,
                      height: isFocused ? 55 : 44,
                      child: GestureDetector(
                        onTap: () => _focusOnPlace(place),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: isFocused ? markerColor : AppTheme.surfaceDark,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFocused ? Colors.white : markerColor,
                              width: isFocused ? 2.5 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: markerColor.withValues(alpha: 0.5),
                                blurRadius: isFocused ? 12 : 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              place.category.iconName,
                              style: TextStyle(fontSize: isFocused ? 20 : 16),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // 2. Top Header & Radar Status
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _isLoadingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentGold),
                              )
                            : const Icon(Icons.radar, color: AppTheme.accentGold, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'HERITAGE RADAR',
                                style: GoogleFonts.cinzel(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppTheme.accentGold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '${_filteredPlaces.length} Heritage Sites in Range',
                                style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: AppTheme.accentGold, size: 20),
                          tooltip: 'Recenter to Current Location',
                          onPressed: _fetchLiveLocation,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category selector pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: HeritageCategory.values.map((cat) {
                        bool isSel = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                              _applyFilters();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.accentGold : AppTheme.surfaceDark.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSel ? AppTheme.accentGold : Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat.iconName, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  cat.displayName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    color: isSel ? AppTheme.backgroundDark : AppTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Radius selector chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        {'label': 'All India', 'val': 2500.0},
                        {'label': 'Within 250 km', 'val': 250.0},
                        {'label': 'Within 50 km', 'val': 50.0},
                        {'label': 'Within 15 km', 'val': 15.0},
                      ].map((rad) {
                        double val = rad['val'] as double;
                        bool isSel = _maxRadiusKm == val;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _maxRadiusKm = val;
                              _applyFilters();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.accentGold.withValues(alpha: 0.3) : AppTheme.surfaceDark.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? AppTheme.accentGold : Colors.white12),
                            ),
                            child: Text(
                              rad['label'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                color: isSel ? AppTheme.accentGoldLight : AppTheme.textMuted,
                              ),
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

          // 3. Bottom Sliding Carousel of Places
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 190,
              child: _filteredPlaces.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'No monuments found in this radar filter.',
                          style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        bool isFocused = _focusedPlace?.id == place.id;

                        return GestureDetector(
                          onTap: () => _focusOnPlace(place),
                          child: Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: BoxDecoration(
                              gradient: AppTheme.darkCardGradient,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isFocused ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.25),
                                width: isFocused ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isFocused ? AppTheme.accentGold.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.5),
                                  blurRadius: isFocused ? 14 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Thumbnail Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(19),
                                    bottomLeft: Radius.circular(19),
                                  ),
                                  child: Image.network(
                                    place.heroImage,
                                    width: 110,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 110,
                                      color: AppTheme.surfaceDark,
                                      child: const Icon(Icons.account_balance, color: AppTheme.accentGold),
                                    ),
                                  ),
                                ),
                                // Details & Navigate Button
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          place.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.marcellus(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.accentGoldLight,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.directions_walk, size: 14, color: AppTheme.accentGold),
                                            const SizedBox(width: 4),
                                            Text(
                                              place.liveDistance ?? 'Calculating...',
                                              style: GoogleFonts.outfit(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => LocationService.launchNavigation(
                                                  place.lat,
                                                  place.lng,
                                                  placeName: place.name,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppTheme.accentGold,
                                                  foregroundColor: AppTheme.backgroundDark,
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  minimumSize: const Size(0, 32),
                                                ),
                                                child: const Text('NAVIGATE', style: TextStyle(fontSize: 11)),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            IconButton(
                                              icon: const Icon(Icons.info_outline, color: AppTheme.accentGold, size: 20),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => DetailsScreen(place: place),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
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
        ],
      ),
    );
  }
}