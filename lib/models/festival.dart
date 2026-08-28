// lib/models/festival.dart

class Festival {
  final String id;
  final String name;
  final String hindiName;
  final String dates;
  final String month;
  final String region;
  final String state;
  final String significance;
  final List<String> rituals;
  final List<String> culinarySpecialties;
  final String image;
  final String duration;
  final String bestSpotToExperience;
  bool isReminderSet;

  Festival({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.dates,
    required this.month,
    required this.region,
    required this.state,
    required this.significance,
    required this.rituals,
    required this.culinarySpecialties,
    required this.image,
    required this.duration,
    required this.bestSpotToExperience,
    this.isReminderSet = false,
  });
}
