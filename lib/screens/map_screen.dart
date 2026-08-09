// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _userLatlng = const LatLng(23.4000, 88.5000); // Default to near Krishnanagar
  bool _isLoadingLocation = true;

  // 🌟 TUMHARA CUSTOM PROTOTYPE DATABASE 🌟
  final List<Map<String, dynamic>> _customPlaces = [
    {
      'name': 'Krishnanagar Palace (Rajbari)',
      'lat': 23.397924,
      'lng': 88.461961,
      'image': 'https://share.google/fp52NlvLWkoUVJ8ER', // Royal Image
      'live_distance': 'Calculating...',
    },
    {
      'name': 'Cathedral Church, Krishnanagar',
      'lat': 23.405867,
      'lng': 88.478288,
      'image': 'https://share.google/PJoHHQf3AtVchpu0c', // Church Image
      'live_distance': 'Calculating...',
    },
    {
      'name': 'ISKCON Temple, Mayapur',
      'lat': 23.423900,
      'lng': 88.389200,
      'image': 'https://share.google/w4JYepZkK2okbHlFD', // Temple Image
      'live_distance': 'Calculating...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("GPS Disabled");

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception("Permission Denied");
      }
      if (permission == LocationPermission.deniedForever) throw Exception("Permission Permanently Denied");

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      ).timeout(const Duration(seconds: 5));
      
      setState(() {
        _userLatlng = LatLng(position.latitude, position.longitude);
        _updateDistances(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      _mapController.move(_userLatlng, 12.0);
    } catch (e) {
      // Agar GPS fail hua, toh default Krishnanagar center se calculate kar lega
      _updateDistances(_userLatlng.latitude, _userLatlng.longitude);
      setState(() => _isLoadingLocation = false);
    }
  }

  // 🧮 Live GPS se real distance calculate karega
  void _updateDistances(double userLat, double userLng) {
    for (var place in _customPlaces) {
      double dist = Geolocator.distanceBetween(
        userLat, userLng, 
        place['lat'] as double, place['lng'] as double
      );
      place['live_distance'] = "${(dist / 1000).toStringAsFixed(1)} km";
    }
  }

  // 🚀 Google Maps Navigation Launch Karega (Advanced)
  Future<void> _launchGoogleMaps(double destLat, double destLng) async {
    // 1. Sabse pehle phone ke native Google Maps app mein direct "Driving Mode" open karne ki koshish
    final Uri nativeMapsUrl = Uri.parse('google.navigation:q=$destLat,$destLng&mode=d');
    
    // 2. Agar phone mein Google Maps app disable hai, toh Chrome/Browser mein rasta dikhayega
    final Uri browserUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng');
    
    try {
      if (await canLaunchUrl(nativeMapsUrl)) {
        await launchUrl(nativeMapsUrl);
      } else if (await canLaunchUrl(browserUrl)) {
        await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not open Google Maps");
      }
    } catch (e) {
      debugPrint("Navigation Error: $e");
    }
  }

  void _moveToLocation(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _userLatlng, initialZoom: 12.0),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.sanskriti',
              ),
              MarkerLayer(
                markers: [
                  // User's Live Location Marker
                  Marker(
                    point: _userLatlng,
                    width: 60, height: 60,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Center(child: Icon(Icons.my_location, color: Colors.blue, size: 30)),
                    ),
                  ),
                  // Custom Heritage Places Markers
                  ..._customPlaces.map((place) => Marker(
                    point: LatLng(place['lat'] as double, place['lng'] as double),
                    width: 50, height: 50,
                    child: GestureDetector(
                      onTap: () => _moveToLocation(place['lat'] as double, place['lng'] as double),
                      child: const Icon(Icons.location_on, color: AppTheme.accentGold, size: 40),
                    ),
                  )),
                ],
              ),
            ],
          ),

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
                    const Text("Local Heritage Radar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textLight)),
                    const Spacer(),
                    GestureDetector(
                      onTap: _fetchLiveLocation,
                      child: const Icon(Icons.my_location, color: AppTheme.textMuted, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _customPlaces.length,
                itemBuilder: (context, index) {
                  final place = _customPlaces[index];
                  return GestureDetector(
                    onTap: () => _moveToLocation(place['lat'] as double, place['lng'] as double),
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
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 110, color: AppTheme.backgroundDark,
                                child: const Icon(Icons.account_balance, color: AppTheme.textMuted, size: 40),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    place['name'], 
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.accentGold)
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_walk, size: 16, color: AppTheme.textMuted),
                                      const SizedBox(width: 4),
                                      Text(place['live_distance'], style: const TextStyle(color: AppTheme.textMuted)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentGold, 
                                      foregroundColor: AppTheme.backgroundDark, 
                                      minimumSize: const Size(double.infinity, 35)
                                    ),
                                    onPressed: () => _launchGoogleMaps(place['lat'] as double, place['lng'] as double), 
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