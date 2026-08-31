// lib/screens/spatial_viewer_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

class SpatialModelData {
  final String id;
  final String title;
  final String dynasty;
  final String century;
  final String ruinsImageUrl;
  final String restoredImageUrl;
  final String description;
  final List<ArchitecturalHotspot> hotspots;

  const SpatialModelData({
    required this.id,
    required this.title,
    required this.dynasty,
    required this.century,
    required this.ruinsImageUrl,
    required this.restoredImageUrl,
    required this.description,
    required this.hotspots,
  });
}

class ArchitecturalHotspot {
  final String name;
  final String sanskritTerm;
  final String description;
  final Offset relativePosition; // 0.0 to 1.0

  const ArchitecturalHotspot({
    required this.name,
    required this.sanskritTerm,
    required this.description,
    required this.relativePosition,
  });
}

class SpatialViewerScreen extends StatefulWidget {
  const SpatialViewerScreen({super.key});

  @override
  State<SpatialViewerScreen> createState() => _SpatialViewerScreenState();
}

class _SpatialViewerScreenState extends State<SpatialViewerScreen> {
  int _selectedModelIndex = 0;
  double _rotationX = 0.2;
  double _rotationY = 0.4;
  final double _zoom = 1.0;
  double _timeTravelSplit = 0.5; // 0.0 (Ruins) to 1.0 (Restored)
  ArchitecturalHotspot? _selectedHotspot;
  bool _isWireframeMode = true;

  static const List<SpatialModelData> _models = [
    SpatialModelData(
      id: 'konark-sun-temple',
      title: 'Konark Sun Temple (Surya Devalaya)',
      dynasty: 'Eastern Ganga Dynasty (King Narasimhadeva I)',
      century: '13th Century CE (1250 CE)',
      ruinsImageUrl: 'https://images.unsplash.com/photo-1609825488888-3a766db05542?w=800&q=80',
      restoredImageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800&q=80',
      description: 'Conceived as a colossal 24-wheeled chariot of the Sun God pulled by seven galloping horses. The 229-foot Vimana once dominated the Bay of Bengal coastline.',
      hotspots: [
        ArchitecturalHotspot(
          name: 'Sundial Wheels',
          sanskritTerm: 'Kaalachakra (24 Spokes)',
          description: 'Each of the 24 wheels acts as a high-precision solar chronometer measuring time down to seconds using sunlight shadow lines.',
          relativePosition: Offset(0.3, 0.7),
        ),
        ArchitecturalHotspot(
          name: 'Jagamohana (Audience Hall)',
          sanskritTerm: 'Pida Deula',
          description: 'The surviving 128-foot stepped pyramidal porch crowned with a colossal Amalaka stone and iron beams.',
          relativePosition: Offset(0.5, 0.45),
        ),
        ArchitecturalHotspot(
          name: 'Natamandira (Dance Pavilion)',
          sanskritTerm: 'Nritya Mandapa',
          description: 'Pillared open hall carved with hundreds of celestial dancing figures (Alasa Kanyas) playing classical musical instruments.',
          relativePosition: Offset(0.75, 0.65),
        ),
      ],
    ),
    SpatialModelData(
      id: 'kailash-temple',
      title: 'Kailash Temple (Cave 16, Ellora)',
      dynasty: 'Rashtrakuta Dynasty (King Krishna I)',
      century: '8th Century CE (756–774 CE)',
      ruinsImageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800&q=80',
      restoredImageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?w=800&q=80',
      description: 'The world\'s largest monolithic rock-cut structure, carved top-down from a single basalt cliff without scaffolding, excavating 200,000+ tonnes of stone.',
      hotspots: [
        ArchitecturalHotspot(
          name: 'Sanctum Vimana',
          sanskritTerm: 'Garbhagriha & Dravidian Shikhara',
          description: 'Multi-tiered Dravidian tower soaring 98 feet into the sky, flanked by five secondary shrines symbolizing Mount Kailash.',
          relativePosition: Offset(0.5, 0.35),
        ),
        ArchitecturalHotspot(
          name: 'Elephant Plinth',
          sanskritTerm: 'Gaja Pitha',
          description: 'A subterranean plinth supported by life-sized monolithic elephants carved directly from the living mountain rock.',
          relativePosition: Offset(0.4, 0.8),
        ),
        ArchitecturalHotspot(
          name: 'Victory Monoliths',
          sanskritTerm: 'Dhvajastambha Pillars',
          description: 'Two freestanding 50-foot victory columns intricately carved with Shiva Trishula iconography.',
          relativePosition: Offset(0.2, 0.55),
        ),
      ],
    ),
    SpatialModelData(
      id: 'hampi-stone-chariot',
      title: 'Hampi Stone Chariot (Vittala Complex)',
      dynasty: 'Vijayanagara Empire (King Krishnadevaraya)',
      century: '16th Century CE',
      ruinsImageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800&q=80',
      restoredImageUrl: 'https://images.unsplash.com/photo-1609825488888-3a766db05542?w=800&q=80',
      description: 'One of India\'s three celebrated stone chariots, dedicated to Garuda. Built from interlocking granite blocks disguised as a monolithic chariot.',
      hotspots: [
        ArchitecturalHotspot(
          name: 'Granite Rotating Wheels',
          sanskritTerm: 'Chakra Yantra',
          description: 'Intricately carved granite wheels with floral spokes that were originally designed to rotate on stone axles.',
          relativePosition: Offset(0.35, 0.75),
        ),
        ArchitecturalHotspot(
          name: 'Musical Ranga Mandapa',
          sanskritTerm: 'Sangeeta Sthambha',
          description: '56 carved granite pillars that emit distinct musical notes when tapped, tuned to classical swaras.',
          relativePosition: Offset(0.7, 0.4),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentModel = _models[_selectedModelIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Title Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SPATIAL COMPUTING & AR',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                        Text(
                          '3D Spatial Heritage & Kaalchakra',
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGoldLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isWireframeMode ? Icons.view_in_ar : Icons.compare,
                      color: AppTheme.accentGold,
                    ),
                    onPressed: () {
                      setState(() {
                        _isWireframeMode = !_isWireframeMode;
                      });
                    },
                    tooltip: _isWireframeMode ? 'Switch to Time-Travel' : 'Switch to 3D Wireframe',
                  ),
                ],
              ),
            ),

            // Monument Selector Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _models.length,
                itemBuilder: (context, index) {
                  final m = _models[index];
                  final isSelected = index == _selectedModelIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(m.title.split('(').first.trim()),
                      selected: isSelected,
                      selectedColor: AppTheme.accentGold,
                      backgroundColor: AppTheme.surfaceDark,
                      labelStyle: GoogleFonts.outfit(
                        color: isSelected ? Colors.black : AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.2),
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedModelIndex = index;
                            _selectedHotspot = null;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Main Interactive Spatial / Kaalchakra Canvas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0F14),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
                    ),
                    child: _isWireframeMode
                        ? _build3DWireframeViewer(currentModel)
                        : _buildKaalchakraTimeTravelSlider(currentModel),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Selected Hotspot / Architecture Details Card
            if (_selectedHotspot != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentGold.withValues(alpha: 0.15),
                        ),
                        child: const Icon(Icons.architecture, color: AppTheme.accentGold, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedHotspot!.name,
                                  style: GoogleFonts.cinzel(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedHotspot = null),
                                  child: const Icon(Icons.close, color: AppTheme.textMuted, size: 16),
                                ),
                              ],
                            ),
                            Text(
                              _selectedHotspot!.sanskritTerm,
                              style: GoogleFonts.rozhaOne(
                                color: AppTheme.accentGold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedHotspot!.description,
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
              ),
            ] else ...[
              // Controls hint
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isWireframeMode ? Icons.touch_app : Icons.swap_horiz,
                            color: AppTheme.accentGold,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isWireframeMode
                                ? 'Drag to rotate 3D wireframe • Tap gold markers'
                                : 'Slide horizontally for Time-Travel Era comparison',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isWireframeMode ? '3D VIEW' : 'KAALCHAKRA',
                          style: GoogleFonts.outfit(
                            color: AppTheme.accentGold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _build3DWireframeViewer(SpatialModelData model) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx * 0.01;
          _rotationX = (_rotationX - details.delta.dy * 0.01).clamp(-1.0, 1.0);
        });
      },
      child: Stack(
        children: [
          // Background starry / spatial grid
          CustomPaint(
            painter: SpatialGridPainter(
              rotationX: _rotationX,
              rotationY: _rotationY,
            ),
            child: const SizedBox.expand(),
          ),

          // Central 3D Temple Wireframe Projection
          Center(
            child: CustomPaint(
              size: const Size(260, 260),
              painter: Temple3DWireframePainter(
                rotationX: _rotationX,
                rotationY: _rotationY,
                zoom: _zoom,
              ),
            ),
          ),

          // Interactive Hotspots on model
          ...model.hotspots.map((hotspot) {
            final double left = hotspot.relativePosition.dx * 280;
            final double top = hotspot.relativePosition.dy * 280;
            final isSelected = _selectedHotspot == hotspot;

            return Positioned(
              left: 40 + left,
              top: 30 + top,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHotspot = hotspot;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.accentGold : Colors.black.withValues(alpha: 0.8),
                    border: Border.all(
                      color: AppTheme.accentGold,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGold.withValues(alpha: 0.6),
                        blurRadius: isSelected ? 12 : 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.touch_app,
                    color: isSelected ? Colors.black : AppTheme.accentGold,
                    size: 14,
                  ),
                ),
              ),
            );
          }),

          // Compass & Zoom UI
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Transform.rotate(
                angle: _rotationY,
                child: const Icon(Icons.navigation, color: AppTheme.accentGold, size: 18),
              ),
            ),
          ),

          // Dynasty Badge overlay
          Positioned(
            bottom: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.dynasty,
                    style: GoogleFonts.outfit(
                      color: AppTheme.accentGoldLight,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.century,
                    style: GoogleFonts.outfit(
                      color: AppTheme.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaalchakraTimeTravelSlider(SpatialModelData model) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Layer 1: Golden Era Reconstructed Image
            Positioned.fill(
              child: Image.network(
                model.restoredImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF2C2214),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 40),
                  ),
                ),
              ),
            ),

            // Layer 2: Clipped Current Archaeological State
            ClipRect(
              clipper: _SplitClipper(_timeTravelSplit),
              child: SizedBox(
                width: width,
                height: height,
                child: Image.network(
                  model.ruinsImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF14141E),
                    child: const Center(
                      child: Icon(Icons.account_balance, color: AppTheme.textMuted, size: 40),
                    ),
                  ),
                ),
              ),
            ),

            // Split Line & Drag Handle
            Positioned(
              left: (width * _timeTravelSplit) - 1.5,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                color: AppTheme.accentGold,
              ),
            ),

            Positioned(
              left: (width * _timeTravelSplit) - 20,
              top: (height / 2) - 20,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _timeTravelSplit = (_timeTravelSplit + details.delta.dx / width).clamp(0.05, 0.95);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.goldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGold.withValues(alpha: 0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.compare_arrows,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),

            // Top Badges (Ruins vs Golden Era)
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  'CURRENT STATE (RUINS)',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGold),
                ),
                child: Text(
                  '12TH CE GOLDEN ERA RESTORATION',
                  style: GoogleFonts.outfit(
                    color: AppTheme.accentGold,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SplitClipper extends CustomClipper<Rect> {
  final double splitRatio;
  _SplitClipper(this.splitRatio);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * splitRatio, size.height);
  }

  @override
  bool shouldReclip(covariant _SplitClipper oldClipper) {
    return oldClipper.splitRatio != splitRatio;
  }
}

class SpatialGridPainter extends CustomPainter {
  final double rotationX;
  final double rotationY;

  SpatialGridPainter({required this.rotationX, required this.rotationY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentGold.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles simulating radar ground
    for (double r = 40; r < 200; r += 40) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 80),
          width: r * 2,
          height: r * 0.7,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpatialGridPainter oldDelegate) {
    return oldDelegate.rotationX != rotationX || oldDelegate.rotationY != rotationY;
  }
}

class Temple3DWireframePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final double zoom;

  Temple3DWireframePainter({
    required this.rotationX,
    required this.rotationY,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final goldPaint = Paint()
      ..color = AppTheme.accentGold
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final faintGoldPaint = Paint()
      ..color = AppTheme.accentGold.withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final cosY = math.cos(rotationY);
    final sinY = math.sin(rotationY);
    final sinX = math.sin(rotationX);

    // 3D Point projection helper
    Offset project(double x, double y, double z) {
      final rotX = x * cosY - z * sinY;
      final rotZ = x * sinY + z * cosY;
      final rotY = y - rotZ * sinX * 0.3;
      return Offset(center.dx + rotX * zoom, center.dy + rotY * zoom);
    }

    // Draw multi-tier temple tower (Vimana/Shikhara)
    final top = project(0, -90, 0);
    final amalaka = project(0, -75, 0);

    // Amalaka stone disk
    canvas.drawCircle(amalaka, 12, goldPaint);
    canvas.drawLine(top, amalaka, goldPaint);

    // 4-Tier Shikhara steps
    List<List<Offset>> tiers = [];
    final List<double> widths = [25.0, 45.0, 65.0, 85.0];
    final List<double> heights = [-55.0, -30.0, -5.0, 20.0];

    for (int i = 0; i < 4; i++) {
      double w = widths[i];
      double h = heights[i];
      final p1 = project(-w, h, -w);
      final p2 = project(w, h, -w);
      final p3 = project(w, h, w);
      final p4 = project(-w, h, w);

      canvas.drawLine(p1, p2, faintGoldPaint);
      canvas.drawLine(p2, p3, goldPaint);
      canvas.drawLine(p3, p4, goldPaint);
      canvas.drawLine(p4, p1, faintGoldPaint);

      tiers.add([p1, p2, p3, p4]);
    }

    // Connect spire apex to top tier
    for (var pt in tiers[0]) {
      canvas.drawLine(amalaka, pt, goldPaint);
    }

    // Plinth Base (Adhisthana)
    final baseTop1 = project(-100, 30, -100);
    final baseTop2 = project(100, 30, -100);
    final baseTop3 = project(100, 30, 100);
    final baseTop4 = project(-100, 30, 100);

    canvas.drawLine(baseTop1, baseTop2, faintGoldPaint);
    canvas.drawLine(baseTop2, baseTop3, goldPaint);
    canvas.drawLine(baseTop3, baseTop4, goldPaint);
    canvas.drawLine(baseTop4, baseTop1, faintGoldPaint);

    final baseBot1 = project(-105, 60, -105);
    final baseBot2 = project(105, 60, -105);
    final baseBot3 = project(105, 60, 105);
    final baseBot4 = project(-105, 60, 105);

    canvas.drawLine(baseBot1, baseBot2, faintGoldPaint);
    canvas.drawLine(baseBot2, baseBot3, goldPaint);
    canvas.drawLine(baseBot3, baseBot4, goldPaint);
    canvas.drawLine(baseBot4, baseBot1, faintGoldPaint);

    // Vertical plinth pillars
    canvas.drawLine(baseTop2, baseBot2, goldPaint);
    canvas.drawLine(baseTop3, baseBot3, goldPaint);
    canvas.drawLine(baseTop4, baseBot4, goldPaint);
  }

  @override
  bool shouldRepaint(covariant Temple3DWireframePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.zoom != zoom;
  }
}
