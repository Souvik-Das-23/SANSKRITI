// lib/screens/ai_assistant_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../services/ai_heritage_service.dart';
import 'details_screen.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AiMessage> _messages = [];
  bool _isTyping = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Hindi', 'Bengali'];

  @override
  void initState() {
    super.initState();
    _messages.add(
      AiMessage(
        text: 'Namaste! 🙏 I am **Veda AI**, your Indian Cultural & Architectural Scholar.\n\n'
            'Ask me about dynastic sagas, temple architecture (Nagara vs Dravidian), custom travel itineraries, or use the **AI Heritage Lens** to scan artifacts!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = text.trim();
    _controller.clear();

    setState(() {
      _messages.add(
        AiMessage(
          text: userMsg,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    _scrollToBottom();

    final response = await AiHeritageService.getResponse(
      userMsg,
      language: _selectedLanguage,
    );

    setState(() {
      _messages.add(response);
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _triggerAiLensScan(String artifactType) {
    _sendMessage('Scan: $artifactType');
  }

  void _showScanPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.document_scanner, color: AppTheme.accentGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  'AI HERITAGE LENS SCANNER',
                  style: GoogleFonts.outfit(
                    color: AppTheme.accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Select an artifact or monument to simulate camera scan & AI identification:',
              style: GoogleFonts.outfit(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            _buildScanOptionTile(
              title: 'Chola Bronze Nataraja Sculpture',
              subtitle: 'Lost-wax casting, 10th Century CE, Thanjavur',
              icon: Icons.auto_fix_high,
              onTap: () {
                Navigator.pop(context);
                _triggerAiLensScan('Chola Bronze Nataraja');
              },
            ),
            _buildScanOptionTile(
              title: 'Bankura Terracotta Folk Horse',
              subtitle: 'GI Tag No. 83, Panchmura Rarh Bengal Craft',
              icon: Icons.palette,
              onTap: () {
                Navigator.pop(context);
                _triggerAiLensScan('Bankura Terracotta Horse');
              },
            ),
            _buildScanOptionTile(
              title: 'Medieval Sandstone Temple Frieze',
              subtitle: 'Nagara relief carving, 12th Century CE',
              icon: Icons.account_balance,
              onTap: () {
                Navigator.pop(context);
                _triggerAiLensScan('Medieval Sandstone Temple Frieze');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.25)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.accentGold.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: AppTheme.accentGold, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.accentGold, size: 14),
        onTap: onTap,
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final suggestedPrompts = AiHeritageService.getSuggestedPrompts(_selectedLanguage);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.accentGold, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF8E44AD), Color(0xFF6C3483)],
                ),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veda Cultural AI',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGoldLight,
                  ),
                ),
                Text(
                  'Scholar & Architecture AI Guide',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // AI Lens Camera Button
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: AppTheme.accentGold),
            tooltip: 'AI Heritage Lens Scanner',
            onPressed: _showScanPickerModal,
          ),
        ],
      ),
      body: Column(
        children: [
          // Language selector bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.surfaceDark.withValues(alpha: 0.5),
            child: Row(
              children: [
                const Icon(Icons.translate, color: AppTheme.accentGold, size: 14),
                const SizedBox(width: 8),
                Text(
                  'Language:',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                ..._languages.map((lang) {
                  final isSelected = lang == _selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.accentGold : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.accentGold : AppTheme.accentGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          lang,
                          style: GoogleFonts.outfit(
                            color: isSelected ? Colors.black : AppTheme.textMuted,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Veda AI is consulting ancient chronicles...',
                    style: GoogleFonts.outfit(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Preset Chips Horizontal Scroller
          Container(
            height: 38,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = suggestedPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: AppTheme.surfaceDark,
                    side: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    label: Text(
                      prompt,
                      style: GoogleFonts.outfit(
                        color: AppTheme.accentGoldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      if (prompt.contains('AI Lens')) {
                        _showScanPickerModal();
                      } else {
                        _sendMessage(prompt);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              border: Border(
                top: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.document_scanner, color: AppTheme.accentGold),
                  tooltip: 'Scan Artifact',
                  onPressed: _showScanPickerModal,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDark,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Ask Veda AI or scan artifacts...',
                        hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                    ),
                    child: const Icon(Icons.send, color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AiMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 50),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8E44AD), Color(0xFF5B2C6F)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.text,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    // AI Response
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14, right: 30),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          border: Border.all(
            color: msg.isScanResult
                ? AppTheme.accentGold
                : AppTheme.accentGold.withValues(alpha: 0.25),
            width: msg.isScanResult ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Badge / Scan Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: msg.isScanResult ? AppTheme.accentGold : const Color(0xFF8E44AD),
                  ),
                  child: Icon(
                    msg.isScanResult ? Icons.document_scanner : Icons.auto_awesome,
                    color: msg.isScanResult ? Colors.black : Colors.white,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  msg.isScanResult ? 'AI HERITAGE LENS' : 'VEDA AI SCHOLAR',
                  style: GoogleFonts.outfit(
                    color: AppTheme.accentGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Scan Metadata Grid if available
            if (msg.scanMetadata != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E28),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: msg.scanMetadata!.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.key,
                            style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                          ),
                          Text(
                            e.value,
                            style: GoogleFonts.outfit(
                              color: AppTheme.accentGoldLight,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Main Answer Text
            Text(
              msg.text,
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 13,
                height: 1.45,
              ),
            ),

            // Monument Link Action if available
            if (msg.placeReferenceId != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final place = HeritageRepository.getPlaceById(msg.placeReferenceId!);
                  if (place != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(place: place),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.explore, color: AppTheme.accentGold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'View Monument Chronicles',
                        style: GoogleFonts.outfit(
                          color: AppTheme.accentGold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
}
