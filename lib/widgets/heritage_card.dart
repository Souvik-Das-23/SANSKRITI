// lib/widgets/heritage_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models/heritage_place.dart';
import '../screens/details_screen.dart';
import '../services/favorites_service.dart';

class HeritageCard extends StatelessWidget {
  final HeritagePlace place;
  final VoidCallback? onFavoriteChanged;

  const HeritageCard({
    super.key,
    required this.place,
    this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final favService = FavoritesService();
    final isFav = favService.isPlaceFavorite(place.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(place: place),
          ),
        );
      },
      child: Container(
        height: place.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.accentGold.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero Image with error builder
              Image.network(
                place.heroImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.surfaceDark,
                  child: const Center(
                    child: Icon(Icons.account_balance, color: AppTheme.accentGold, size: 48),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.surfaceDark,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),

              // Gradient Overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.heroOverlayGradient,
                ),
              ),

              // Top Badges (Category & Bookmark)
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(place.category.iconName, style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            place.category.displayName,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bookmark button
                    GestureDetector(
                      onTap: () {
                        favService.togglePlaceFavorite(place);
                        if (onFavoriteChanged != null) {
                          onFavoriteChanged!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isFav ? AppTheme.accentGold : Colors.white24,
                          ),
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppTheme.crimsonRed : Colors.white70,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Information
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (place.isUnescoSite)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.6), width: 0.8),
                        ),
                        child: Text(
                          'UNESCO WORLD HERITAGE',
                          style: GoogleFonts.outfit(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGoldLight,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    Text(
                      place.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.marcellus(
                        color: AppTheme.accentGoldLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppTheme.accentGold, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (place.liveDistance != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.cardDarkElevated,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              place.liveDistance!,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentGold,
                              ),
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
      ),
    );
  }
}
