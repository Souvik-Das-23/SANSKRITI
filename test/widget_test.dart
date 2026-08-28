import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanskriti/data/festival_repository.dart';
import 'package:sanskriti/data/heritage_repository.dart';
import 'package:sanskriti/data/kala_bazaar_repository.dart';
import 'package:sanskriti/data/quiz_repository.dart';
import 'package:sanskriti/main.dart';
import 'package:sanskriti/models/craft_item.dart';
import 'package:sanskriti/models/heritage_place.dart';
import 'package:sanskriti/screens/splash_screen.dart';
import 'package:sanskriti/services/ai_heritage_service.dart';
import 'package:sanskriti/services/favorites_service.dart';
import 'package:sanskriti/services/location_service.dart';

void main() {
  group('HeritageRepository Tests', () {
    test('getAllPlaces returns rich collection of Indian monuments', () {
      final places = HeritageRepository.getAllPlaces();
      expect(places.length, greaterThanOrEqualTo(10));
      expect(places.any((p) => p.name.contains('Taj Mahal')), isTrue);
      expect(places.any((p) => p.name.contains('Hampi')), isTrue);
      expect(places.any((p) => p.name.contains('Konark')), isTrue);
    });

    test('getPlacesByCategory filters correctly', () {
      final temples = HeritageRepository.getPlacesByCategory(HeritageCategory.temples);
      expect(temples.isNotEmpty, isTrue);
      expect(temples.every((p) => p.category == HeritageCategory.temples), isTrue);

      final forts = HeritageRepository.getPlacesByCategory(HeritageCategory.forts);
      expect(forts.isNotEmpty, isTrue);
      expect(forts.every((p) => p.category == HeritageCategory.forts), isTrue);
    });

    test('searchPlaces searches by monument name, location, and dynasty', () {
      final agraResults = HeritageRepository.searchPlaces('Agra');
      expect(agraResults.any((p) => p.name == 'Taj Mahal'), isTrue);

      final cholaResults = HeritageRepository.searchPlaces('Chola');
      expect(cholaResults.isNotEmpty, isTrue);
      expect(cholaResults.first.dynastyOrPatron.contains('Chola'), isTrue);
    });
  });

  group('Festival & KalaBazaar Repositories Tests', () {
    test('FestivalRepository returns major Indian festivals', () {
      final festivals = FestivalRepository.getAllFestivals();
      expect(festivals.isNotEmpty, isTrue);
      expect(festivals.any((f) => f.name.contains('Durga Puja')), isTrue);
      expect(festivals.any((f) => f.name.contains('Diwali')), isTrue);
    });

    test('KalaBazaarRepository provides GI-tagged authentic craft items', () {
      final crafts = KalaBazaarRepository.getAllCrafts();
      expect(crafts.isNotEmpty, isTrue);
      expect(crafts.any((c) => c.hasGiTag), isTrue);

      final pottery = KalaBazaarRepository.getCraftsByType(CraftType.pottery);
      expect(pottery.isNotEmpty, isTrue);
    });
  });

  group('Services Tests', () {
    test('LocationService distance calculation works accurately', () {
      // Distance between New Delhi (28.6139, 77.2090) and Taj Mahal Agra (27.1751, 78.0421) ~ 180-210 km
      double dist = LocationService.calculateDistanceInKm(28.6139, 77.2090, 27.1751, 78.0421);
      expect(dist, greaterThan(150.0));
      expect(dist, lessThan(250.0));
    });

    test('FavoritesService toggles bookmarks properly', () {
      final favService = FavoritesService();
      final place = HeritageRepository.getAllPlaces().first;

      bool initial = favService.isPlaceFavorite(place.id);
      favService.togglePlaceFavorite(place);
      expect(favService.isPlaceFavorite(place.id), !initial);

      // Restore
      favService.togglePlaceFavorite(place);
      expect(favService.isPlaceFavorite(place.id), initial);
    });

    test('AiHeritageService provides rich historical answers', () async {
      final response = await AiHeritageService.getResponse('Tell me about Hampi');
      expect(response.text.contains('Hampi'), isTrue);
      expect(response.placeReferenceId, 'hampi-ruins');
    });

    test('QuizRepository contains questions with valid correct indexes', () {
      expect(QuizRepository.questions.isNotEmpty, isTrue);
      for (var q in QuizRepository.questions) {
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(q.options.length));
        expect(q.explanation.isNotEmpty, isTrue);
      }
    });
  });

  group('Widget Smoke Test', () {
    testWidgets('SplashScreen displays Sanskriti branding and shloka', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );
      expect(find.text('Sanskriti'), findsOneWidget);
      expect(find.text('॥ वसुधैव कुटुम्बकम् ॥'), findsOneWidget);
      expect(find.text('Discover India\'s Rich Heritage'), findsOneWidget);
    });
  });
}