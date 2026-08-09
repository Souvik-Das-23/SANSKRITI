// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // Naya package import kiya
import '../app_theme.dart';
import '../data/mock_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  // Default to Delhi agar GPS off ho
  LatLng _userLatlng = LatLng(MockData.userLocation['lat']!, MockData.userLocation['lng']!);
  bool _isLoadingLocation = true;
  List<Map<String, dynamic>> _dynamicPlaces = [];

  @override
  void initState() {
    super.initState();
    _dynamicPlaces = List.from(MockData.nearbyPlaces); // Copy data
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return _stopLoading();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return _stopLoading();
    }
    
    if (permission == LocationPermission.deniedForever) return _stopLoading();

    // Get Live Position
    Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    
    setState(() {
      _userLatlng = LatLng(position.latitude, position.longitude);
      _isLoadingLocation = false;
      _calculateDistances(); // Calculate exact distance from your phone!
    });

    _mapController.move(_userLatlng, 13.0);
  }

  void _calculateDistances() {
    for (var place in _dynamicPlaces) {
      double distanceInMeters = Geolocator.distanceBetween(
        _userLatlng.latitude, _userLatlng.longitude,
        place['lat'], place['lng'],
      );
      // Convert to km and save
      place['live_distance'] = "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
    }
  }

  void _stopLoading() {
    setState(() => _isLoadingLocation = false);
  }

  void _moveToLocation(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLatlng,
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.sanskriti',
              ),
              MarkerLayer(
                markers: [
                  // Live User Location Marker
                  Marker(
                    point: _userLatlng,
                    width: 60,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.my_location, color: Colors.blue, size: 30),
                      ),
                    ),
                  ),
                  // Heritage Markers
                  ..._dynamicPlaces.map((place) => Marker(
                    point: LatLng(place['lat'], place['lng']),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _moveToLocation(place['lat'], place['lng']),
                      child: const Icon(Icons.account_balance, color: AppTheme.accentGold, size: 35),
                    ),
                  )),
                ],
              ),
            ],
          ),

          // 2. Header Overlay 
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoadingLocation 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppTheme.accentGold, strokeWidth: 2))
                      : const Icon(Icons.radar, color: AppTheme.accentGold),
                    const SizedBox(width: 8),
                    const Text("Live Heritage Radar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textLight)),
                    const Spacer(),
                    GestureDetector(
                      onTap: _fetchLiveLocation, // Tap to refresh live location
                      child: const Icon(Icons.my_location, color: AppTheme.textMuted, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Cards (With Image Fix & Live Distance)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dynamicPlaces.length,
                itemBuilder: (context, index) {
                  final place = _dynamicPlaces[index];
                  return GestureDetector(
                    onTap: () => _moveToLocation(place['lat'], place['lng']),
                    child: Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            child: Image.network(
                              place['image'],
                              width: 110,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              // 👇 YEH FIX HAIN AAPKE RED ERROR KA 👇
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 110,
                                  color: AppTheme.backgroundDark,
                                  child: const Icon(Icons.account_balance, color: AppTheme.textMuted, size: 40),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(place['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.accentGold)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_walk, size: 16, color: AppTheme.textMuted),
                                      const SizedBox(width: 4),
                                      // 👇 LIVE DISTANCE YAHAN DIKHEGA 👇
                                      Text(place['live_distance'] ?? place['distance'], style: const TextStyle(color: AppTheme.textMuted)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentGold, 
                                      foregroundColor: AppTheme.backgroundDark,
                                      minimumSize: const Size(double.infinity, 35),
                                    ),
                                    onPressed: () {}, 
                                    child: const Text("Navigate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  )
                                ],
                              ),
                            ),
                          )
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