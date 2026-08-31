import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

class HeritageZone {
  final String name;
  final String region;
  final String icon;
  final String sealTitle;
  final List<String> monuments;
  bool isUnlocked;

  HeritageZone({
    required this.name,
    required this.region,
    required this.icon,
    required this.sealTitle,
    required this.monuments,
    this.isUnlocked = false,
  });
}

class HeritagePassportScreen extends StatefulWidget {
  const HeritagePassportScreen({super.key});

  @override
  State<HeritagePassportScreen> createState() => _HeritagePassportScreenState();
}

class _HeritagePassportScreenState extends State<HeritagePassportScreen> {
  final List<HeritageZone> _zones = [
    HeritageZone(
      name: 'North Zone (Uttranchal & Gangetic Plain)',
      region: 'Delhi, UP, Punjab, Kashmir',
      icon: '🏔️',
      sealTitle: 'Imperial Dynastic Crest',
      monuments: ['Taj Mahal (Agra)', 'Qutub Minar (Delhi)', 'Amber Fort (Jaipur)', 'Varanasi Ghats'],
      isUnlocked: true,
    ),
    HeritageZone(
      name: 'South Zone (Dravida Desam)',
      region: 'Tamil Nadu, Karnataka, Kerala',
      icon: '🛕',
      sealTitle: 'Dravidian Gopuram Seal',
      monuments: ['Hampi Ruins (Vijayanagara)', 'Brihadisvara Temple (Thanjavur)', 'Meenakshi Amman (Madurai)'],
      isUnlocked: true,
    ),
    HeritageZone(
      name: 'East Zone (Kalinga & Banga)',
      region: 'West Bengal, Odisha, Bihar',
      icon: '🌊',
      sealTitle: 'Kalinga Solar & Rarh Crest',
      monuments: ['Konark Sun Temple', 'Krishnanagar Rajbari', 'Victoria Memorial', 'Puri Jagannath'],
      isUnlocked: true,
    ),
    HeritageZone(
      name: 'West Zone (Maratha & Desert Citadels)',
      region: 'Maharashtra, Rajasthan, Gujarat',
      icon: '🏰',
      sealTitle: 'Rajputana & Sahyadri Seal',
      monuments: ['Ajanta & Ellora Caves', 'Rani ki Vav', 'Chittorgarh Fort', 'Modhera Sun Temple'],
      isUnlocked: false,
    ),
    HeritageZone(
      name: 'Central Zone (Madhya Desha)',
      region: 'Madhya Pradesh, Chhattisgarh',
      icon: '🗿',
      sealTitle: 'Sanchi Sacred Wheel Crest',
      monuments: ['Khajuraho Temples', 'Sanchi Stupa', 'Bhimbetka Rock Shelters'],
      isUnlocked: false,
    ),
    HeritageZone(
      name: 'North-East Zone (Pragjyotisha & Hills)',
      region: 'Assam, Meghalaya, Manipur',
      icon: '🌿',
      sealTitle: 'Brahmaputra Living Seal',
      monuments: ['Kamakhya Temple (Guwahati)', 'Majuli River Island', 'Unakoti Rock Carvings'],
      isUnlocked: false,
    ),
  ];

  int get _unlockedCount => _zones.where((z) => z.isUnlocked).length;

  void _toggleZoneUnlock(int index) {
    setState(() {
      _zones[index].isUnlocked = !_zones[index].isUnlocked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        content: Text(
          _zones[index].isUnlocked
              ? '✨ Stamped ${_zones[index].sealTitle} in your Sanskriti Passport!'
              : 'Stamp removed.',
          style: GoogleFonts.outfit(color: AppTheme.accentGold),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCertificateDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF14141E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentGold, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium, color: AppTheme.accentGold, size: 48),
              const SizedBox(height: 10),
              Text(
                'OFFICIAL CERTIFICATE',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Royal Heritage Scholar',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGoldLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 1,
                width: 120,
                color: AppTheme.accentGold.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 14),
              Text(
                'This certifies that the explorer has explored India\'s civilizational chronicles across multiple geographic zones and demonstrated mastery in heritage stewardship.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'PASSPORT NO',
                        style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 9),
                      ),
                      Text(
                        'IN-SKT-2026',
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'STAMP SEAL',
                        style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 9),
                      ),
                      Text(
                        '$_unlockedCount / 6 ZONES',
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.share, size: 16, color: Colors.black),
                label: Text(
                  'Share Scholar Badge',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppTheme.surfaceDark,
                      content: Text(
                        '🎉 Heritage Certificate ready for export & sharing!',
                        style: GoogleFonts.outfit(color: AppTheme.accentGold),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceDark,
                        border: Border.all(
                          color: AppTheme.accentGold.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppTheme.accentGold,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NATIONAL CULTURAL PASSPORT',
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                        ),
                      ),
                      Text(
                        'Sanskriti Yatra Passport',
                        style: GoogleFonts.cinzel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGoldLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Royal Leather-bound Passport Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B1B2A), Color(0xFF0F0F18)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.45), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_moon_outlined, color: AppTheme.accentGold, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'REPUBLIC OF INDIA',
                              style: GoogleFonts.cinzel(
                                color: AppTheme.accentGoldLight,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'OFFICIAL E-PASSPORT',
                            style: GoogleFonts.outfit(
                              color: AppTheme.accentGold,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.goldGradient,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.person, color: Colors.black, size: 36),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Souvik Das',
                                style: GoogleFonts.cinzel(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Royal Heritage Scholar • Tier III',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Passport ID: IN-SANS-2026-7890',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Zone Exploration Progress',
                          style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                        ),
                        Text(
                          '$_unlockedCount of 6 Zones Stamped',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGoldLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _unlockedCount / 6.0,
                        backgroundColor: Colors.black45,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                        minHeight: 6,
                      ),
                    ),

                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(Icons.card_membership, color: AppTheme.accentGold, size: 16),
                      label: Text(
                        'View Royal Scholar Certificate',
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: _showCertificateDialog,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'COLLECTED ZONE SEALS & STAMPS',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap any zone seal to mark monuments visited and stamp your passport:',
                style: GoogleFonts.outfit(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),

              // Zone Stamps Grid
              ..._zones.asMap().entries.map((entry) {
                final index = entry.key;
                final zone = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: zone.isUnlocked
                          ? AppTheme.accentGold.withValues(alpha: 0.6)
                          : AppTheme.accentGold.withValues(alpha: 0.15),
                      width: zone.isUnlocked ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: zone.isUnlocked
                                  ? AppTheme.accentGold.withValues(alpha: 0.2)
                                  : Colors.black26,
                            ),
                            child: Text(zone.icon, style: const TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        zone.name,
                                        style: GoogleFonts.cinzel(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _toggleZoneUnlock(index),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: zone.isUnlocked
                                              ? AppTheme.accentGold
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.accentGold),
                                        ),
                                        child: Text(
                                          zone.isUnlocked ? 'STAMPED 🪶' : 'STAMP +',
                                          style: GoogleFonts.outfit(
                                            color: zone.isUnlocked ? Colors.black : AppTheme.accentGold,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  zone.sealTitle,
                                  style: GoogleFonts.outfit(
                                    color: zone.isUnlocked ? AppTheme.accentGold : AppTheme.textMuted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: zone.monuments.map((m) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: zone.isUnlocked
                                    ? AppTheme.accentGold.withValues(alpha: 0.3)
                                    : Colors.white10,
                              ),
                            ),
                            child: Text(
                              m,
                              style: GoogleFonts.outfit(
                                color: zone.isUnlocked ? Colors.white : AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
