import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/traditions_repository.dart';
import '../models/tradition.dart';

class ParamparaScreen extends StatefulWidget {
  const ParamparaScreen({super.key});

  @override
  State<ParamparaScreen> createState() => _ParamparaScreenState();
}

class _ParamparaScreenState extends State<ParamparaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPlayingChant = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button & header
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
                                'INTANGIBLE LIVING HERITAGE',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              Text(
                                'Sanskriti Parampara',
                                style: GoogleFonts.cinzel(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGoldLight,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Intro hero banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF8E44AD).withValues(alpha: 0.25),
                              AppTheme.surfaceDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF9B59B6).withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF8E44AD), Color(0xFF6C3483)],
                                ),
                              ),
                              child: const Icon(Icons.theater_comedy, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'India\'s Living Soul & Traditions',
                                    style: GoogleFonts.cinzel(
                                      color: AppTheme.accentGoldLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Discover classical dance mudras, ancient martial disciplines, metallurgy marvels, and Vedic sacred chants.',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.textMuted,
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tab Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.accentGold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: AppTheme.textMuted,
                          labelStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          unselectedLabelStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                          tabs: const [
                            Tab(text: 'Dances'),
                            Tab(text: 'Martial Arts'),
                            Tab(text: 'Sciences'),
                            Tab(text: 'Vedic Chants'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTraditionList(TraditionCategory.classicalDance),
              _buildTraditionList(TraditionCategory.martialArt),
              _buildTraditionList(TraditionCategory.ancientScience),
              _buildTraditionList(TraditionCategory.vedicChant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTraditionList(TraditionCategory category) {
    final items = TraditionsRepository.getByCategory(category);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildTraditionCard(context, item);
      },
    );
  }

  Widget _buildTraditionCard(BuildContext context, TraditionItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentGold.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with tag overlay
            Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: const Color(0xFF1F1F2E),
                    child: const Center(
                      child: Icon(Icons.palette_outlined, color: AppTheme.accentGold, size: 48),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.accentGold.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      item.tag,
                      style: GoogleFonts.outfit(
                        color: AppTheme.accentGold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.accentGold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.originState,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item.eraOrPeriod,
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGoldLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.cinzel(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.hindiTitle,
                              style: GoogleFonts.rozhaOne(
                                color: AppTheme.accentGold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.accentGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'LIVING ICH',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    item.shortDescription,
                    style: GoogleFonts.outfit(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  // Shloka box if present
                  if (item.sanskritShloka != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1610),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentGold.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'SACRED SANSKRIT SHLOKA',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.accentGold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.sanskritShloka!,
                            style: GoogleFonts.rozhaOne(
                              color: AppTheme.accentGoldLight,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.menu_book, color: AppTheme.accentGold, size: 16),
                          label: Text(
                            'Deep Chronicle',
                            style: GoogleFonts.outfit(
                              color: AppTheme.accentGold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _showDetailModal(context, item),
                        ),
                      ),
                      if (item.category == TraditionCategory.vedicChant) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentGold,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            icon: Icon(
                              _isPlayingChant ? Icons.pause : Icons.play_arrow,
                              size: 18,
                              color: Colors.black,
                            ),
                            label: Text(
                              _isPlayingChant ? 'Pause Chant' : 'Listen Chant',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPlayingChant = !_isPlayingChant;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppTheme.surfaceDark,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    _isPlayingChant
                                        ? '🔔 Playing sacred Vedic resonance audio...'
                                        : 'Chant paused.',
                                    style: GoogleFonts.outfit(color: AppTheme.accentGold),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context, TraditionItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
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

              Text(
                item.unescoStatus,
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                style: GoogleFonts.cinzel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGoldLight,
                ),
              ),
              Text(
                item.hindiTitle,
                style: GoogleFonts.rozhaOne(
                  fontSize: 16,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 16),

              // Full chronicle
              Text(
                'HISTORICAL CHRONICLE & MASTERY',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.fullChronicle,
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Key Features
              Text(
                'SIGNATURE ELEMENTS & PROTOCOLS',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              ...item.keyFeatures.map((feat) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppTheme.accentGold, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feat,
                            style: GoogleFonts.outfit(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Cultural Significance Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppTheme.accentGold, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'CIVILIZATIONAL SIGNIFICANCE',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.culturalSignificance,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              if (item.shlokaMeaning != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1420),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF8E44AD).withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ENGLISH PHILOSOPHICAL TRANSLATION',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFBB86FC),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.shlokaMeaning!,
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
