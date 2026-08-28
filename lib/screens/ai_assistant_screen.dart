// lib/screens/ai_assistant_screen.dart
import 'dart:ui';
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
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickPrompts = [
    '🏛️ How is Dravidian architecture different from Nagara?',
    '🗓️ 3-day cultural itinerary for Rajasthan forts',
    '🪨 What is the secret of the Konark Sun Temple wheels?',
    '🎨 Tell me about Krishnanagar clay doll heritage',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: '॥ नमस्ते ॥ I am Veda, your AI Cultural & Historical Companion.\n\nAsk me anything regarding India\'s dynastic chronicles, temple architecture, UNESCO monuments, or customized travel routes.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = text.trim();
    _inputController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMsg, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    final aiResponse = await AiHeritageService.getResponse(userMsg);
    final linkedPlace = aiResponse.placeReferenceId != null
        ? HeritageRepository.getPlaceById(aiResponse.placeReferenceId!)
        : null;

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: aiResponse.text,
            isUser: false,
            timestamp: DateTime.now(),
            linkedPlace: linkedPlace,
          ),
        );
      });
      _scrollToBottom();
    }
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Modern Glass Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGlass,
                border: Border(bottom: BorderSide(color: AppTheme.accentGold.withValues(alpha: 0.2))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, color: AppTheme.backgroundDark, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VEDA CULTURAL AI',
                        style: GoogleFonts.cinzel(
                          color: AppTheme.accentGoldLight,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Online • Dynasties & Architecture Scholar',
                        style: GoogleFonts.outfit(color: AppTheme.emeraldGreen, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Prompt Chips
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(_quickPrompts[index]),
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
                          _quickPrompts[index],
                          style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.accentGoldLight),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(context, msg);
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
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentGold),
                    ),
                    const SizedBox(width: 10),
                    Text('Veda is formulating historical response...', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ),

            // Bottom Input Bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 6, 16, 85),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGlass,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          onSubmitted: _sendMessage,
                          style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13.5),
                          decoration: InputDecoration(
                            hintText: 'Ask Veda about temples, dynasties, heritage...',
                            hintStyle: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12.5),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _sendMessage(_inputController.text),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.goldGradient,
                          ),
                          child: const Icon(Icons.send_rounded, color: AppTheme.backgroundDark, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isUser ? AppTheme.accentGold.withValues(alpha: 0.18) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: msg.isUser ? AppTheme.accentGold.withValues(alpha: 0.5) : AppTheme.accentGold.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                height: 1.5,
                color: msg.isUser ? AppTheme.accentGoldLight : AppTheme.textLight,
              ),
            ),
            if (msg.linkedPlace != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsScreen(place: msg.linkedPlace!)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          msg.linkedPlace!.heroImage,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(width: 44, height: 44, color: AppTheme.cardDark),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.linkedPlace!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.marcellus(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGoldLight,
                              ),
                            ),
                            Text(
                              'Explore Chronicle & Audio Guide →',
                              style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.accentGold),
                            ),
                          ],
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

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final HeritagePlace? linkedPlace;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.linkedPlace,
  });
}
