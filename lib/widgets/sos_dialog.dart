// lib/widgets/sos_dialog.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../services/location_service.dart';

class SosDialog extends StatefulWidget {
  const SosDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SosDialog(),
    );
  }

  @override
  State<SosDialog> createState() => _SosDialogState();
}

class _SosDialogState extends State<SosDialog> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final bool _isBroadcasting = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _callEmergency(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPos = LocationService.currentUserLocation ?? LocationService.defaultLocation;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppTheme.crimsonRed, width: 2),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.all(20),
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.crimsonRed.withValues(
                    alpha: 0.2 + (0.4 * _pulseController.value),
                  ),
                ),
                child: const Icon(Icons.emergency_share, color: AppTheme.crimsonRed, size: 28),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OFF-GRID SOS RADAR',
                  style: GoogleFonts.cinzel(
                    color: AppTheme.crimsonRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Pilgrim & Heritage Safety Beacon',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardDarkElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.crimsonRed.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bluetooth_searching, color: AppTheme.accentGold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _isBroadcasting ? 'Broadcasting Mesh SOS Beacon...' : 'Broadcast Paused',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Relaying emergency telemetry to nearby peer devices & archaeological outpost stations via offline Bluetooth protocol.',
                    style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '📍 GPS Coordinates: ${userPos.latitude.toStringAsFixed(5)}, ${userPos.longitude.toStringAsFixed(5)}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency Helplines
            Text(
              'Direct Emergency Lines:',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callEmergency('112'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.crimsonRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.call, size: 16),
                    label: Text('Police (112)', style: GoogleFonts.outfit(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callEmergency('1363'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.cardDark,
                      foregroundColor: AppTheme.accentGold,
                      side: const BorderSide(color: AppTheme.accentGold),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.tour, size: 16),
                    label: Text('Tourist (1363)', style: GoogleFonts.outfit(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('DISMISS', style: GoogleFonts.outfit(color: AppTheme.textMuted)),
        ),
      ],
    );
  }
}
