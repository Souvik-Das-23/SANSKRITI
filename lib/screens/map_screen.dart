// lib/screens/map_screen.dart
import 'dart:ui';
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
  List<HeritagePlace> _allPlaces = [];
  List<HeritagePlace> _filteredPlaces = [];
  final HeritageCategory _selectedCategory = HeritageCategory.all;
  double _maxRadiusKm = 1500.0; // Default All India
  LatLng _userLatlng = const LatLng(28.6139, 77.2090); // Default New Delhi
  HeritagePlace? _focusedPlace;

  final List<double> _radiusOptions = [15.0, 50.0, 250.0, 1500.0];

  @override
  void initState() {
    super.initState();
    _allPlaces = HeritageRepository.getAllPlaces();
    _filteredPlaces = _allPlaces;
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    final pos = await LocationService.getCurrentLocation();
    _userLatlng = LatLng(pos.latitude, pos.longitude);
    LocationService.updatePlacesDistances(_allPlaces, pos);
    _applyFilters();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // 1. Interactive Dark Tile Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLatlng,
              initialZoom: 5.5,
              minZoom: 3.5,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.sanskriti',
              ),
              MarkerLayer(
                markers: [
                  // User GPS Pulse Marker
                  Marker(
                    point: _userLatlng,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.sapphireBlue.withValues(alpha: 0.25),
                        border: Border.all(color: AppTheme.sapphireBlue, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.my_location, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  // Monument Category Markers
                  ..._filteredPlaces.map((place) {
                    final isFocused = _focusedPlace?.id == place.id;
                    return Marker(
                      point: LatLng(place.lat, place.lng),
                      width: isFocused ? 54 : 42,
                      height: isFocused ? 54 : 42,
                      child: GestureDetector(
                        onTap: () => _focusOnPlace(place),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isFocused ? AppTheme.goldGradient : null,
                            color: isFocused ? null : AppTheme.cardDarkElevated,
                            border: Border.all(
                              color: isFocused ? AppTheme.accentGoldLight : AppTheme.accentGold,
                              width: isFocused ? 2.5 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isFocused
                                    ? AppTheme.accentGold.withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.5),
                                blurRadius: isFocused ? 12 : 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              place.category.iconName,
                              style: TextStyle(fontSize: isFocused ? 20 : 15),
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

          // 2. Top Modern Floating Glass Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceGlass,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.emeraldGreen,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.emeraldGreen,
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'HERITAGE RADAR',
                                    style: GoogleFonts.cinzel(
                                      color: AppTheme.accentGold,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '${_filteredPlaces.length} Sites within ${_maxRadiusKm >= 900 ? "All India" : "${_maxRadiusKm.toInt()} km"}',
                                    style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.my_location, color: AppTheme.accentGold, size: 20),
                              onPressed: () {
                                _mapController.move(_userLatlng, 12.0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Radius Selector Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _radiusOptions.map((radius) {
                        bool isSelected = _maxRadiusKm == radius;
                        String label = radius >= 900 ? 'All India' : '< ${radius.toInt()} km';
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _maxRadiusKm = radius;
                              _applyFilters();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.accentGold : AppTheme.surfaceDark.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              label,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppTheme.backgroundDark : AppTheme.accentGoldLight,
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

          // 3. Bottom Sliding Carousel
          if (_filteredPlaces.isNotEmpty)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = _filteredPlaces[index];
                    final isFocused = _focusedPlace?.id == place.id;

                    return GestureDetector(
                      onTap: () => _focusOnPlace(place),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 280,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.glassCardGradient,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isFocused ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.3),
                            width: isFocused ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isFocused ? AppTheme.accentGold.withValues(alpha: 0.25) : Colors.black54,
                              blurRadius: isFocused ? 14 : 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      place.heroImage,
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 80,
                                        height: 100,
                                        color: AppTheme.surfaceDark,
                                        child: const Icon(Icons.account_balance, color: AppTheme.accentGold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
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
                                        Text(
                                          place.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            if (place.liveDistance != null)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.surfaceDark,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                                                ),
                                                child: Text(
                                                  place.liveDistance!,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.accentGold,
                                                  ),
                                                ),
                                              ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DetailsScreen(place: place)),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.accentGold,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  'View',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.backgroundDark,
                                                  ),
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