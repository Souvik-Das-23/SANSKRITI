// lib/models/craft_item.dart

enum CraftType {
  all,
  textiles,
  pottery,
  metalcraft,
  paintings,
  woodcraft,
  jewelry,
}

extension CraftTypeExtension on CraftType {
  String get displayName {
    switch (this) {
      case CraftType.all:
        return 'All Crafts';
      case CraftType.textiles:
        return 'Handloom & Textiles';
      case CraftType.pottery:
        return 'Terracotta & Pottery';
      case CraftType.metalcraft:
        return 'Metal & Bell Craft';
      case CraftType.paintings:
        return 'Folk Art & Paintings';
      case CraftType.woodcraft:
        return 'Wood & Stone Carvings';
      case CraftType.jewelry:
        return 'Tribal & Temple Jewelry';
    }
  }
}

class CraftItem {
  final String id;
  final String title;
  final String artisanName;
  final String villageOrCity;
  final String state;
  final CraftType craftType;
  final String image;
  final String description;
  final String heritageHistory;
  final String rawMaterials;
  final String estimatedPrice;
  final bool hasGiTag;
  final String makingTime;
  final String artisanContactInfo;

  CraftItem({
    required this.id,
    required this.title,
    required this.artisanName,
    required this.villageOrCity,
    required this.state,
    required this.craftType,
    required this.image,
    required this.description,
    required this.heritageHistory,
    required this.rawMaterials,
    required this.estimatedPrice,
    required this.hasGiTag,
    required this.makingTime,
    required this.artisanContactInfo,
  });
}
