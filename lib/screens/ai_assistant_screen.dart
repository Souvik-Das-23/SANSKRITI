import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';
import '../services/ai_heritage_service.dart';
import 'details_screen.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AiMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Initial welcome greeting from Veda AI
    _messages.add(
      AiMessage(
        text: 'नमस्ते! I am **Veda**, your Sanskriti Cultural & Heritage AI Assistant.\n\n'
            'Ask me anything about India\'s ancient monuments, temple architecture (Dravidian/Nagara), dynastic chronicles, sacred festivals, or custom travel itineraries!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String query) async {
    if (query.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(
        AiMessage(
          text: query,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    _scrollToBottom();

    final response = await AiHeritageService.getResponse(query);

    setState(() {
      _isTyping = false;
      _messages.add(response);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final suggestedPrompts = AiHeritageService.getSuggestedPrompts();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 20),
            const SizedBox(width: 8),
            Text(
              'Veda Cultural AI',
              style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentGold),
            tooltip: 'Clear Chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  AiMessage(
                    text: 'Chat history cleared. How may I assist your cultural exploration today? 🙏',
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggested prompts horizontally scrollable
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = suggestedPrompts[index];
                return GestureDetector(
                  onTap: () => _sendMessage(prompt),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Text(
                        prompt,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppTheme.accentGoldLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentGold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Veda is consulting the historical chronicles...',
                    style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              border: Border(top: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.3))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Ask about temples, dynasties, routes...',
                          hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) => _sendMessage(val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_textController.text),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.goldGradient,
                      ),
                      child: const Icon(Icons.send, color: AppTheme.backgroundDark, size: 18),
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

  Widget _buildMessageBubble(AiMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: Text(
            msg.text,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.backgroundDark,
            ),
          ),
        ),
      );
    } else {
      HeritagePlace? referencedPlace;
      if (msg.placeReferenceId != null) {
        referencedPlace = HeritageRepository.getPlaceById(msg.placeReferenceId!);
      }

      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14, right: 30),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceDark,
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'VEDA AI',
                    style: GoogleFonts.cinzel(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                msg.text,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.textLight,
                ),
              ),
              if (referencedPlace != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(place: referencedPlace!),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            referencedPlace.heroImage,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                referencedPlace.name,
                                style: GoogleFonts.marcellus(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGoldLight,
                                ),
                              ),
                              Text(
                                'Tap to explore details & map',
                                style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: AppTheme.accentGold, size: 12),
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
}
