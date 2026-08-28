// lib/screens/kala_bazaar_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/kala_bazaar_repository.dart';
import '../models/craft_item.dart';

class KalaBazaarScreen extends StatefulWidget {
  const KalaBazaarScreen({super.key});

  @override
  State<KalaBazaarScreen> createState() => _KalaBazaarScreenState();
}

class _KalaBazaarScreenState extends State<KalaBazaarScreen> {
  CraftType _selectedType = CraftType.all;
  List<CraftItem> _crafts = [];

  @override
  void initState() {
    super.initState();
    _loadCrafts();
  }

  void _loadCrafts() {
    setState(() {
      _crafts = KalaBazaarRepository.getCraftsByType(_selectedType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AUTHENTIC ARTISANS',
                    style: GoogleFonts.outfit(
                      color: AppTheme.accentGold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kala Bazaar',
                    style: GoogleFonts.cinzel(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGoldLight,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Discover verified GI-tagged crafts from rural Indian master guilds.',
                    style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),

            // Craft Type Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: CraftType.values.map((type) {
                    bool isSelected = _selectedType == type;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = type;
                          _loadCrafts();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppTheme.goldGradient : null,
                          color: isSelected ? null : AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          type.displayName,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Crafts Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemCount: _crafts.length,
                itemBuilder: (context, index) {
                  final craft = _crafts[index];
                  return _buildCraftCard(context, craft);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftCard(BuildContext context, CraftItem craft) {
    return GestureDetector(
      onTap: () => _showCraftDetailsModal(context, craft),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.glassCardGradient,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Craft Image
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      craft.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.cardDark),
                    ),
                    if (craft.hasGiTag)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'GI-TAGGED',
                            style: GoogleFonts.outfit(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.backgroundDark,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Info
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            craft.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.marcellus(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGoldLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${craft.villageOrCity}, ${craft.state}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            craft.estimatedPrice.split(' ')[0],
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Guild',
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.backgroundDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCraftDetailsModal(BuildContext context, CraftItem craft) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: AppTheme.surfaceGlass,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        craft.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      craft.name,
                      style: GoogleFonts.marcellus(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentGoldLight,
                      ),
                    ),
                    Text(
                      '${craft.villageOrCity}, ${craft.state} • ${craft.craftType.displayName}',
                      style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.accentGold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      craft.description,
                      style: GoogleFonts.outfit(fontSize: 13.5, height: 1.5, color: AppTheme.textLight),
                    ),
                    const SizedBox(height: 16),
                    _buildModalInfoRow('Raw Materials', craft.rawMaterials),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Crafting Time', craft.makingTime),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Artisan Guild', craft.artisanContactInfo),
                    const SizedBox(height: 8),
                    _buildModalInfoRow('Estimated Value', craft.estimatedPrice),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Connecting to ${craft.artisanContactInfo}...',
                                style: GoogleFonts.outfit(),
                              ),
                              backgroundColor: AppTheme.surfaceDark,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGold,
                          foregroundColor: AppTheme.backgroundDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: const Icon(Icons.handshake_outlined, size: 18),
                        label: const Text('CONNECT WITH ARTISAN GUILD'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(fontSize: 12.5, color: AppTheme.textLight),
          ),
        ),
      ],
    );
  }
}
