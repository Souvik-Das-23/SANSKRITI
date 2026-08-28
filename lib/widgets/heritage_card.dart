// lib/widgets/heritage_card.dart
import 'dart:ui';
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
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppTheme.accentGold.withValues(alpha: 0.28),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero Image with smooth error & loading
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
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category pill with frosted blur
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.accentGold.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(place.category.iconName, style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                place.category.displayName,
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGoldLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bookmark button with frosted glass
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: GestureDetector(
                          onTap: () {
                            favService.togglePlaceFavorite(place);
                            if (onFavoriteChanged != null) {
                              onFavoriteChanged!();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isFav ? AppTheme.crimsonRed : Colors.white24,
                                width: 0.8,
                              ),
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppTheme.crimsonRed : Colors.white70,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Glassmorphic Card Info
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accentGold.withValues(alpha: 0.2),
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (place.isUnescoSite)
                            Row(
                              children: [
                                const Icon(Icons.stars, color: AppTheme.accentGoldShimmer, size: 10),
                                const SizedBox(width: 3),
                                Text(
                                  'UNESCO HERITAGE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentGoldLight,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 2),
                          Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.marcellus(
                              color: AppTheme.accentGoldLight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppTheme.accentGold, size: 12),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  place.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              if (place.liveDistance != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 0.6),
                                  ),
                                  child: Text(
                                    place.liveDistance!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
