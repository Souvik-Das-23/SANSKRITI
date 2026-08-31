import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanskriti/data/festival_repository.dart';
import 'package:sanskriti/data/heritage_repository.dart';
import 'package:sanskriti/data/kala_bazaar_repository.dart';
import 'package:sanskriti/data/quiz_repository.dart';
import 'package:sanskriti/data/traditions_repository.dart';
import 'package:sanskriti/models/craft_item.dart';
import 'package:sanskriti/models/heritage_place.dart';
import 'package:sanskriti/models/tradition.dart';
import 'package:sanskriti/screens/heritage_passport_screen.dart';
import 'package:sanskriti/screens/parampara_screen.dart';
import 'package:sanskriti/screens/spatial_viewer_screen.dart';
import 'package:sanskriti/screens/splash_screen.dart';
import 'package:sanskriti/services/ai_heritage_service.dart';
import 'package:sanskriti/services/favorites_service.dart';
import 'package:sanskriti/services/location_service.dart';

void main() {
  group('HeritageRepository Tests', () {
    test('getAllPlaces returns rich collection of Indian monuments', () {
      final places = HeritageRepository.getAllPlaces();
      expect(places.length, greaterThanOrEqualTo(14));
      expect(places.any((p) => p.name.contains('Taj Mahal')), isTrue);
      expect(places.any((p) => p.name.contains('Hampi')), isTrue);
      expect(places.any((p) => p.name.contains('Konark')), isTrue);
      expect(places.any((p) => p.name.contains('Modhera')), isTrue);
      expect(places.any((p) => p.name.contains('Khajuraho')), isTrue);
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

  group('TraditionsRepository (Parampara ICH) Tests', () {
    test('getAllTraditions returns classical dances, martial arts, sciences, and chants', () {
      final traditions = TraditionsRepository.getAllTraditions();
      expect(traditions.length, greaterThanOrEqualTo(8));
      expect(traditions.any((t) => t.id == 'bharatanatyam'), isTrue);
      expect(traditions.any((t) => t.id == 'kalaripayattu'), isTrue);
      expect(traditions.any((t) => t.id == 'rustless-iron-pillar'), isTrue);
      expect(traditions.any((t) => t.id == 'shanti-mantra'), isTrue);
    });

    test('getByCategory filters correctly', () {
      final dances = TraditionsRepository.getByCategory(TraditionCategory.classicalDance);
      expect(dances.isNotEmpty, isTrue);
      expect(dances.every((d) => d.category == TraditionCategory.classicalDance), isTrue);

      final sciences = TraditionsRepository.getByCategory(TraditionCategory.ancientScience);
      expect(sciences.isNotEmpty, isTrue);
      expect(sciences.every((s) => s.category == TraditionCategory.ancientScience), isTrue);
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

    test('AiHeritageService provides rich historical and multilingual answers', () async {
      final response = await AiHeritageService.getResponse('Tell me about Hampi');
      expect(response.text.contains('Hampi'), isTrue);
      expect(response.placeReferenceId, 'hampi-ruins');

      final bengaliResponse = await AiHeritageService.getResponse('কৃষ্ণনগর', language: 'Bengali');
      expect(bengaliResponse.text.contains('কৃষ্ণনগর'), isTrue);
    });

    test('AiHeritageService AI Lens scans artifacts accurately', () async {
      final scanResponse = await AiHeritageService.getResponse('Scan: Chola Bronze Nataraja');
      expect(scanResponse.isScanResult, isTrue);
      expect(scanResponse.scanMetadata != null, isTrue);
      expect(scanResponse.scanMetadata!['Dynasty'], 'Imperial Chola');
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

  group('Widget Smoke Tests', () {
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

    testWidgets('HeritagePassportScreen renders passport and zone seals', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HeritagePassportScreen(),
        ),
      );
      expect(find.text('Sanskriti Yatra Passport'), findsOneWidget);
      expect(find.text('REPUBLIC OF INDIA'), findsOneWidget);
    });

    testWidgets('SpatialViewerScreen renders spatial canvas and chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SpatialViewerScreen(),
        ),
      );
      expect(find.text('Konark Sun Temple'), findsOneWidget);
      expect(find.text('3D Spatial Heritage & Kaalchakra'), findsOneWidget);
    });

    testWidgets('ParamparaScreen renders living traditions and tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ParamparaScreen(),
        ),
      );
      expect(find.text('Sanskriti Parampara'), findsOneWidget);
      expect(find.text('Dances'), findsOneWidget);
    });
  });
}