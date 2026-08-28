// lib/services/favorites_service.dart
import 'package:flutter/foundation.dart';
import '../models/heritage_place.dart';
import '../models/festival.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final Set<String> _favoritePlaceIds = {'taj-mahal', 'hampi-ruins'};
  final Set<String> _savedFestivalIds = {'durga-puja'};

  bool isPlaceFavorite(String placeId) => _favoritePlaceIds.contains(placeId);
  bool isFestivalSaved(String festivalId) => _savedFestivalIds.contains(festivalId);
  bool isFestivalReminded(String festivalId) => _savedFestivalIds.contains(festivalId);

  void togglePlaceFavorite(HeritagePlace place) {
    if (_favoritePlaceIds.contains(place.id)) {
      _favoritePlaceIds.remove(place.id);
      place.isFavorite = false;
    } else {
      _favoritePlaceIds.add(place.id);
      place.isFavorite = true;
    }
    notifyListeners();
  }

  void toggleFestivalSaved(Festival festival) {
    if (_savedFestivalIds.contains(festival.id)) {
      _savedFestivalIds.remove(festival.id);
      festival.isReminderSet = false;
    } else {
      _savedFestivalIds.add(festival.id);
      festival.isReminderSet = true;
    }
    notifyListeners();
  }

  void toggleFestivalReminder(Festival festival) => toggleFestivalSaved(festival);

  List<String> get favoritePlaceIds => _favoritePlaceIds.toList();
  List<String> get savedFestivalIds => _savedFestivalIds.toList();
}
