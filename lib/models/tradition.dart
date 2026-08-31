// lib/models/tradition.dart

enum TraditionCategory {
  classicalDance,
  martialArt,
  ancientScience,
  vedicChant,
}

class TraditionItem {
  final String id;
  final String title;
  final String hindiTitle;
  final String originState;
  final String eraOrPeriod;
  final TraditionCategory category;
  final String tag;
  final String unescoStatus;
  final String shortDescription;
  final String fullChronicle;
  final List<String> keyFeatures;
  final String culturalSignificance;
  final String imageUrl;
  final String? audioChantTranscript;
  final String? sanskritShloka;
  final String? shlokaMeaning;

  const TraditionItem({
    required this.id,
    required this.title,
    required this.hindiTitle,
    required this.originState,
    required this.eraOrPeriod,
    required this.category,
    required this.tag,
    required this.unescoStatus,
    required this.shortDescription,
    required this.fullChronicle,
    required this.keyFeatures,
    required this.culturalSignificance,
    required this.imageUrl,
    this.audioChantTranscript,
    this.sanskritShloka,
    this.shlokaMeaning,
  });
}
