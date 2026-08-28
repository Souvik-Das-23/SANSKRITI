// lib/screens/kala_bazaar_screen.dart
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

  void _showCraftDetails(CraftItem craft) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image & Badges
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      craft.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: AppTheme.cardDark,
                        child: const Icon(Icons.palette, color: AppTheme.accentGold, size: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (craft.hasGiTag)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGold),
                          ),
                          child: Text(
                            '🛡️ GI TAGGED AUTHENTIC CRAFT',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGoldLight,
                            ),
                          ),
                        ),
                      Text(
                        craft.estimatedPrice,
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    craft.title,
                    style: GoogleFonts.marcellus(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGoldLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: AppTheme.accentGold, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          craft.artisanName,
                          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppTheme.accentGold, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${craft.villageOrCity}, ${craft.state}',
                          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 24),

                  Text(
                    'About this Craft:',
                    style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    craft.description,
                    style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight, height: 1.4),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Centuries-old Heritage Legacy:',
                    style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    craft.heritageHistory,
                    style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight, height: 1.4),
                  ),
                  const SizedBox(height: 14),

                  _buildDetailRow('Raw Materials Used', craft.rawMaterials),
                  _buildDetailRow('Crafting Time', craft.makingTime),
                  _buildDetailRow('Artisan Guild', craft.artisanContactInfo),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connected to ${craft.artisanContactInfo}! Representative will reach out.'),
                          backgroundColor: AppTheme.accentGold,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                    icon: const Icon(Icons.support_agent, size: 18),
                    label: const Text('CONNECT WITH ARTISAN GUILD'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textLight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crafts = KalaBazaarRepository.getCraftsByType(_selectedType);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Kala Bazaar — Indian Handicrafts'),
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CraftType.values.map((type) {
                  bool isSel = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: isSel ? AppTheme.goldGradient : null,
                        color: isSel ? null : AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSel ? AppTheme.accentGold : Colors.white12),
                      ),
                      child: Text(
                        type.displayName,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel ? AppTheme.backgroundDark : AppTheme.textLight,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Crafts Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemCount: crafts.length,
              itemBuilder: (context, index) {
                final craft = crafts[index];
                return GestureDetector(
                  onTap: () => _showCraftDetails(craft),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                          child: Image.network(
                            craft.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 120,
                              color: AppTheme.surfaceDark,
                              child: const Icon(Icons.palette, color: AppTheme.accentGold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  craft.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.marcellus(
                                    fontSize: 13,
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
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      craft.estimatedPrice.split('–')[0].trim(),
                                      style: GoogleFonts.cinzel(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentGold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.surfaceDark,
                                      ),
                                      child: const Icon(Icons.arrow_forward, color: AppTheme.accentGold, size: 12),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
