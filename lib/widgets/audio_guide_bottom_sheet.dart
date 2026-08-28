// lib/widgets/audio_guide_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models/heritage_place.dart';
import '../services/audio_service.dart';

class AudioGuideBottomSheet extends StatefulWidget {
  final HeritagePlace place;

  const AudioGuideBottomSheet({super.key, required this.place});

  static void show(BuildContext context, HeritagePlace place) {
    final audio = AudioGuideService();
    audio.loadPlace(place);
    audio.play();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AudioGuideBottomSheet(place: place),
    );
  }

  @override
  State<AudioGuideBottomSheet> createState() => _AudioGuideBottomSheetState();
}

class _AudioGuideBottomSheetState extends State<AudioGuideBottomSheet> {
  final AudioGuideService _audio = AudioGuideService();
  bool _showTranscript = false;

  @override
  void initState() {
    super.initState();
    _audio.addListener(_onAudioUpdate);
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioUpdate);
    super.dispose();
  }

  void _onAudioUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.headphones, color: AppTheme.accentGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'ROYAL HERITAGE AUDIO GUIDE',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textMuted, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Monument Art Disc
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentGold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.place.heroImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Titles
              Text(
                widget.place.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.marcellus(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGoldLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.place.audioGuideTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 16),

              // Progress Bar
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.accentGold,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: AppTheme.accentGoldShimmer,
                  overlayColor: AppTheme.accentGold.withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: _audio.progress,
                  onChanged: (val) => _audio.seekTo(val),
                ),
              ),

              // Time stamps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _audio.formattedCurrentTime,
                      style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                    ),
                    Text(
                      _audio.formattedTotalTime,
                      style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Playback speed button
                  TextButton(
                    onPressed: () => _audio.cyclePlaybackSpeed(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accentGold,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Text(
                      '${_audio.playbackSpeed}x',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Rewind 10s
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: AppTheme.textLight, size: 28),
                    onPressed: () {
                      double newP = (_audio.progress - (10 / _audio.totalSeconds)).clamp(0.0, 1.0);
                      _audio.seekTo(newP);
                    },
                  ),
                  const SizedBox(width: 12),

                  // Main Play / Pause Button
                  GestureDetector(
                    onTap: () => _audio.togglePlayPause(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x66D4AF37),
                            blurRadius: 14,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _audio.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.backgroundDark,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Forward 10s
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: AppTheme.textLight, size: 28),
                    onPressed: () {
                      double newP = (_audio.progress + (10 / _audio.totalSeconds)).clamp(0.0, 1.0);
                      _audio.seekTo(newP);
                    },
                  ),
                  const SizedBox(width: 16),

                  // Ambient Sitar / Temple Bells Soundscape Toggle
                  IconButton(
                    icon: Icon(
                      _audio.ambientMusicEnabled ? Icons.music_note : Icons.music_off,
                      color: _audio.ambientMusicEnabled ? AppTheme.accentGold : AppTheme.textMuted,
                      size: 24,
                    ),
                    tooltip: 'Ambient Temple Soundscape',
                    onPressed: () => _audio.toggleAmbientMusic(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language selector chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['English', 'हिंदी (Hindi)', 'বাংলা (Bengali)', 'संस्कृतम् (Sanskrit)'].map((lang) {
                  bool isSelected = _audio.selectedLanguage.startsWith(lang.split(' ')[0]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(lang, style: GoogleFonts.outfit(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: AppTheme.accentGold,
                      backgroundColor: AppTheme.cardDark,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => _audio.setLanguage(lang),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Transcript accordion toggle
              InkWell(
                onTap: () {
                  setState(() {
                    _showTranscript = !_showTranscript;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.article_outlined, color: AppTheme.accentGold, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Audio Script & Narration Transcript',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _showTranscript ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppTheme.accentGold,
                      ),
                    ],
                  ),
                ),
              ),

              if (_showTranscript) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDarkElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    widget.place.audioGuideScript,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      height: 1.6,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
