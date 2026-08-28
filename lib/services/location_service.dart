// lib/services/location_service.dart
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/heritage_place.dart';

class LocationService {
  static LatLng defaultLocation = const LatLng(23.3979, 88.4620); // Krishnanagar Palace coordinates
  static LatLng? currentUserLocation;

  static Future<LatLng> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return currentUserLocation ?? defaultLocation;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return currentUserLocation ?? defaultLocation;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return currentUserLocation ?? defaultLocation;
      }

      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 4));

      currentUserLocation = LatLng(pos.latitude, pos.longitude);
      return currentUserLocation!;
    } catch (e) {
      debugPrint('Location service error: $e');
      return currentUserLocation ?? defaultLocation;
    }
  }

  static double calculateDistanceInKm(double lat1, double lng1, double lat2, double lng2) {
    double meters = Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    return meters / 1000.0;
  }

  static void updatePlacesDistances(List<HeritagePlace> places, LatLng userPos) {
    for (var place in places) {
      double km = calculateDistanceInKm(userPos.latitude, userPos.longitude, place.lat, place.lng);
      if (km < 1.0) {
        place.liveDistance = '${(km * 1000).toInt()} m';
      } else {
        place.liveDistance = '${km.toStringAsFixed(1)} km';
      }
    }
  }

  static Future<bool> launchNavigation(double destLat, double destLng, {String? placeName}) async {
    final Uri googleMapsAppUrl = Uri.parse('google.navigation:q=$destLat,$destLng&mode=d');
    final Uri googleMapsWebUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng');

    try {
      if (await canLaunchUrl(googleMapsAppUrl)) {
        return await launchUrl(googleMapsAppUrl);
      } else if (await canLaunchUrl(googleMapsWebUrl)) {
        return await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Navigation launch failed: $e');
    }
    return false;
  }
}
