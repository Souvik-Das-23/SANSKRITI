// lib/screens/map_screen.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';
import '../services/location_service.dart';
import 'details_screen.dart';

class DemoLocation {
  final String name;
  final String subtitle;
  final LatLng latLng;
  final String icon;

  const DemoLocation({
    required this.name,
    required this.subtitle,
    required this.latLng,
    required this.icon,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _radarAnimController;

  List<HeritagePlace> _allPlaces = [];
  List<HeritagePlace> _filteredPlaces = [];
  double _maxRadiusKm = 1500.0;
  LatLng _userLatlng = const LatLng(28.6139, 77.2090); // Default Delhi
  HeritagePlace? _focusedPlace;
  bool _isSonarHudMode = false;
  bool _isScanning = false;
  String _activeLocationName = 'Live GPS (Delhi)';

  static const List<DemoLocation> _demoHotspots = [
    DemoLocation(
      name: 'Agra Hotspot',
      subtitle: 'Taj Mahal & Fort (0.8 km)',
      latLng: LatLng(27.1751, 78.0421),
      icon: '🕌',
    ),
    DemoLocation(
      name: 'Hampi Ruins',
      subtitle: 'Vijayanagara (0.4 km)',
      latLng: LatLng(15.3350, 76.4600),
      icon: '🛕',
    ),
    DemoLocation(
      name: 'Varanasi Ghats',
      subtitle: 'Ganga Riverfront (0.5 km)',
      latLng: LatLng(25.3076, 83.0107),
      icon: '🌊',
    ),
    DemoLocation(
      name: 'Konark Solar',
      subtitle: 'Sun Temple (0.6 km)',
      latLng: LatLng(19.8876, 86.0945),
      icon: '☀️',
    ),
    DemoLocation(
      name: 'Jaipur Forts',
      subtitle: 'Amber & Hawa Mahal (0.9 km)',
      latLng: LatLng(26.9855, 75.8513),
      icon: '🏰',
    ),
  ];

  final List<double> _radiusOptions = [15.0, 50.0, 250.0, 1500.0];

  @override
  void initState() {
    super.initState();
    _radarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _allPlaces = HeritageRepository.getAllPlaces();
    _filteredPlaces = _allPlaces;
    _fetchLiveLocation();
  }

  @override
  void dispose() {
    _radarAnimController.dispose();
    super.dispose();
  }

  Future<void> _fetchLiveLocation() async {
    setState(() => _isScanning = true);
    final pos = await LocationService.getCurrentLocation();
    _userLatlng = LatLng(pos.latitude, pos.longitude);
    LocationService.updatePlacesDistances(_allPlaces, pos);
    _activeLocationName = 'Live GPS Position';
    _applyFilters();
    setState(() => _isScanning = false);
  }

  void _teleportToHotspot(DemoLocation spot) {
    setState(() {
      _userLatlng = spot.latLng;
      _activeLocationName = spot.name;
      _isScanning = true;
    });

    for (var p in _allPlaces) {
      double dist = LocationService.calculateDistanceInKm(
        spot.latLng.latitude,
        spot.latLng.longitude,
        p.lat,
        p.lng,
      );
      p.liveDistance = dist < 1.0
          ? '${(dist * 1000).toInt()} m away'
          : '${dist.toStringAsFixed(1)} km away';
    }

    _applyFilters();
    _mapController.move(spot.latLng, 13.5);

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _isScanning = false);
      if (_filteredPlaces.isNotEmpty) {
        _focusOnPlace(_filteredPlaces.first);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.radar, color: AppTheme.accentGold, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '🛰️ Radar Teleported to ${spot.name}! Detecting nearby monuments...',
                style: GoogleFonts.outfit(color: AppTheme.accentGold),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyFilters() {
    var list = List<HeritagePlace>.from(_allPlaces);
    if (_maxRadiusKm < 900.0) {
      list = list.where((p) {
        double dist = LocationService.calculateDistanceInKm(
          _userLatlng.latitude,
          _userLatlng.longitude,
          p.lat,
          p.lng,
        );
        return dist <= _maxRadiusKm;
      }).toList();
    }

    // Sort by proximity
    list.sort((a, b) {
      double distA = LocationService.calculateDistanceInKm(
        _userLatlng.latitude,
        _userLatlng.longitude,
        a.lat,
        a.lng,
      );
      double distB = LocationService.calculateDistanceInKm(
        _userLatlng.latitude,
        _userLatlng.longitude,
        b.lat,
        b.lng,
      );
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
    _mapController.move(LatLng(place.lat, place.lng), 14.5);
  }

  Future<void> _launchNativeNavigation(HeritagePlace place) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${place.lat},${place.lng}&destination_place_id=${Uri.encodeComponent(place.name)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // 1. Interactive Dark Tile Map with Live Radar Overlay
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLatlng,
              initialZoom: 6.0,
              minZoom: 3.5,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.sanskriti',
              ),

              // Animated Radar Sweep on Map
              MarkerLayer(
                markers: [
                  // Real-time rotating Radar Sweep Beam & Range Rings
                  Marker(
                    point: _userLatlng,
                    width: 260,
                    height: 260,
                    child: AnimatedBuilder(
                      animation: _radarAnimController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: MapRadarSweepPainter(
                            angle: _radarAnimController.value * 2 * math.pi,
                          ),
                        );
                      },
                    ),
                  ),

                  // Center GPS Beacon Marker
                  Marker(
                    point: _userLatlng,
                    width: 44,
                    height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentGold.withValues(alpha: 0.2),
                        border: Border.all(color: AppTheme.accentGold, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.radar, color: AppTheme.accentGold, size: 20),
                      ),
                    ),
                  ),

                  // Monument Category Markers with Target Rings
                  ..._filteredPlaces.map((place) {
                    final isFocused = _focusedPlace?.id == place.id;
                    return Marker(
                      point: LatLng(place.lat, place.lng),
                      width: isFocused ? 58 : 44,
                      height: isFocused ? 58 : 44,
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
                                    ? AppTheme.accentGold.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.5),
                                blurRadius: isFocused ? 14 : 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              place.category.iconName,
                              style: TextStyle(fontSize: isFocused ? 22 : 16),
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

          // 2. Fullscreen Tactical Sonar Radar HUD (Overlay Mode)
          if (_isSonarHudMode) _buildTacticalSonarHud(),

          // 3. Top Floating Glass Bar & Live Hotspot Teleporter
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  // Main Radar Header Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                            // Live Blinking Radar Pulse Icon
                            AnimatedBuilder(
                              animation: _radarAnimController,
                              builder: (context, child) {
                                return Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.emeraldGreen,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.emeraldGreen.withValues(
                                          alpha: 0.4 + (_radarAnimController.value * 0.6),
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
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
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppTheme.emeraldGreen.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'LIVE SCAN',
                                          style: GoogleFonts.outfit(
                                            color: AppTheme.emeraldGreen,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$_activeLocationName • ${_filteredPlaces.length} Targets In Range',
                                    style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Tactical HUD Mode Toggle
                            IconButton(
                              icon: Icon(
                                _isSonarHudMode ? Icons.map_outlined : Icons.track_changes,
                                color: AppTheme.accentGold,
                                size: 22,
                              ),
                              tooltip: _isSonarHudMode ? 'Map View' : 'Sonar HUD Mode',
                              onPressed: () {
                                setState(() {
                                  _isSonarHudMode = !_isSonarHudMode;
                                });
                              },
                            ),

                            // GPS Reset Button
                            IconButton(
                              icon: _isScanning
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                                      ),
                                    )
                                  : const Icon(Icons.my_location, color: AppTheme.accentGold, size: 20),
                              tooltip: 'Lock My Live GPS',
                              onPressed: _fetchLiveLocation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // LIVE DEMO / TELEPORT HOTSPOTS BAR
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1610),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.play_circle_fill, color: AppTheme.accentGold, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE DEMO:',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._demoHotspots.map((spot) {
                          final isCurrent = _activeLocationName == spot.name;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              backgroundColor: isCurrent ? AppTheme.accentGold : AppTheme.surfaceDark.withValues(alpha: 0.9),
                              side: BorderSide(
                                color: isCurrent ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.3),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(spot.icon, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    spot.name,
                                    style: GoogleFonts.outfit(
                                      color: isCurrent ? Colors.black : Colors.white,
                                      fontSize: 11,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => _teleportToHotspot(spot),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Radius Selector Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _radiusOptions.map((radius) {
                        bool isSelected = _maxRadiusKm == radius;
                        String label = radius >= 900 ? 'All India Range' : '< ${radius.toInt()} km Radar';
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _maxRadiusKm = radius;
                              _applyFilters();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.accentGold : AppTheme.surfaceDark.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              label,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
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

          // 4. Bottom Target Carousel
          if (!_isSonarHudMode && _filteredPlaces.isNotEmpty)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 145,
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
                        width: 290,
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
                                      height: 105,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 80,
                                        height: 105,
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
                                                  color: const Color(0xFF1E1610),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
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
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _launchNativeNavigation(place),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.surfaceDark,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.navigation, color: AppTheme.accentGold, size: 12),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Navigate',
                                                        style: GoogleFonts.outfit(
                                                          color: AppTheme.accentGold,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => DetailsScreen(place: place)),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                    gradient: AppTheme.goldGradient,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Chronicle',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
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

  Widget _buildTacticalSonarHud() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xF008080C),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 150), // Spacing below top bar

              // Circular Sonar Radar Canvas
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _radarAnimController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(280, 280),
                        painter: TacticalSonarPainter(
                          sweepAngle: _radarAnimController.value * 2 * math.pi,
                          userLocation: _userLatlng,
                          places: _filteredPlaces.take(6).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Live Telemetry Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTelemetryCol('LATITUDE', _userLatlng.latitude.toStringAsFixed(4)),
                      _buildTelemetryCol('LONGITUDE', _userLatlng.longitude.toStringAsFixed(4)),
                      _buildTelemetryCol('SAT LOCK', '12 SATS (±3m)'),
                      _buildTelemetryCol('BEARING', '${((_radarAnimController.value * 360).toInt())}° N'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Detected Targets List
              Expanded(
                flex: 2,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredPlaces.take(4).length,
                  itemBuilder: (context, index) {
                    final place = _filteredPlaces[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14141E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.accentGold.withValues(alpha: 0.15),
                            ),
                            child: Text(place.category.iconName, style: const TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: GoogleFonts.cinzel(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  place.liveDistance ?? 'In Range',
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.emeraldGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.accentGold, size: 14),
                            onPressed: () {
                              setState(() => _isSonarHudMode = false);
                              _focusOnPlace(place);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryCol(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 8, letterSpacing: 1),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: AppTheme.accentGoldLight,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Map Radar Rotating Sweep Painter
class MapRadarSweepPainter extends CustomPainter {
  final double angle;

  MapRadarSweepPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Concentric Rings
    final ringPaint = Paint()
      ..color = AppTheme.accentGold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius * 0.33, ringPaint);
    canvas.drawCircle(center, radius * 0.66, ringPaint);
    canvas.drawCircle(center, radius, ringPaint);

    // Rotating Sweep Sector
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          AppTheme.accentGold.withValues(alpha: 0.35),
          Colors.transparent,
        ],
        transform: GradientRotation(angle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Leading Radar Beam Line
    final linePaint = Paint()
      ..color = AppTheme.accentGoldLight
      ..strokeWidth = 1.5;

    final endPoint = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    canvas.drawLine(center, endPoint, linePaint);
  }

  @override
  bool shouldRepaint(covariant MapRadarSweepPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

// Tactical Sonar Painter
class TacticalSonarPainter extends CustomPainter {
  final double sweepAngle;
  final LatLng userLocation;
  final List<HeritagePlace> places;

  TacticalSonarPainter({
    required this.sweepAngle,
    required this.userLocation,
    required this.places,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dark Background Circle
    final bgPaint = Paint()
      ..color = const Color(0xFF0D0D14)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Grid Concentric Rings
    final ringPaint = Paint()
      ..color = AppTheme.emeraldGreen.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double r = radius * 0.25; r <= radius; r += radius * 0.25) {
      canvas.drawCircle(center, r, ringPaint);
    }

    // Crosshairs
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), ringPaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), ringPaint);

    // Sonar Sweep Gradient
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          AppTheme.emeraldGreen.withValues(alpha: 0.4),
          Colors.transparent,
        ],
        transform: GradientRotation(sweepAngle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Dynamic Blips for nearby monuments
    for (int i = 0; i < places.length; i++) {
      final p = places[i];
      // Simulated polar coordinates based on lat/lng offset
      double dLat = p.lat - userLocation.latitude;
      double dLng = p.lng - userLocation.longitude;
      double distFactor = math.min(math.sqrt(dLat * dLat + dLng * dLng) * 25.0, radius * 0.85);
      if (distFactor < 20) distFactor = 30 + (i * 20.0);
      double angle = math.atan2(dLat, dLng);

      final blipPos = Offset(
        center.dx + distFactor * math.cos(angle),
        center.dy + distFactor * math.sin(angle),
      );

      final blipPaint = Paint()
        ..color = AppTheme.accentGold
        ..style = PaintingStyle.fill;

      canvas.drawCircle(blipPos, 4, blipPaint);

      final glowPaint = Paint()
        ..color = AppTheme.accentGold.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(blipPos, 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TacticalSonarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}