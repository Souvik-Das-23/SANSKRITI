// lib/models/heritage_place.dart

enum HeritageCategory {
  all,
  temples,
  forts,
  caves,
  monuments,
  palaces,
  ghats,
}

extension HeritageCategoryExtension on HeritageCategory {
  String get displayName {
    switch (this) {
      case HeritageCategory.all:
        return 'All';
      case HeritageCategory.temples:
        return 'Temples';
      case HeritageCategory.forts:
        return 'Forts';
      case HeritageCategory.caves:
        return 'Caves';
      case HeritageCategory.monuments:
        return 'Monuments';
      case HeritageCategory.palaces:
        return 'Palaces';
      case HeritageCategory.ghats:
        return 'Sacred Ghats';
    }
  }

  String get iconName {
    switch (this) {
      case HeritageCategory.all:
        return '🏛️';
      case HeritageCategory.temples:
        return '🛕';
      case HeritageCategory.forts:
        return '🏰';
      case HeritageCategory.caves:
        return '🕳️';
      case HeritageCategory.monuments:
        return '🗿';
      case HeritageCategory.palaces:
        return '🏯';
      case HeritageCategory.ghats:
        return '🌊';
    }
  }
}

class HeritagePlace {
  final String id;
  final String name;
  final String hindiName;
  final String tagLine;
  final HeritageCategory category;
  final String location;
  final String state;
  final double lat;
  final double lng;
  final String heroImage;
  final List<String> galleryImages;
  final String description;
  final String history;
  final List<String> architectureHighlights;
  final String dynastyOrPatron;
  final String builtCentury;
  final bool isUnescoSite;
  final String entryFee;
  final String timings;
  final String bestTimeToVisit;
  final double rating;
  final int reviewsCount;
  final String audioGuideTitle;
  final String audioGuideDuration;
  final String audioGuideScript;
  final List<String> culturalSignificance;
  final List<String> nearbyAttractions;
  final double height; // Card presentation height
  bool isFavorite;
  String? liveDistance;

  HeritagePlace({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.tagLine,
    required this.category,
    required this.location,
    required this.state,
    required this.lat,
    required this.lng,
    required this.heroImage,
    required this.galleryImages,
    required this.description,
    required this.history,
    required this.architectureHighlights,
    required this.dynastyOrPatron,
    required this.builtCentury,
    required this.isUnescoSite,
    required this.entryFee,
    required this.timings,
    required this.bestTimeToVisit,
    required this.rating,
    required this.reviewsCount,
    required this.audioGuideTitle,
    required this.audioGuideDuration,
    required this.audioGuideScript,
    required this.culturalSignificance,
    required this.nearbyAttractions,
    this.height = 240.0,
    this.isFavorite = false,
    this.liveDistance,
  });
}
