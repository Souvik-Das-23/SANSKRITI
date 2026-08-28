// lib/services/ai_heritage_service.dart
import 'dart:async';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? placeReferenceId;

  AiMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.placeReferenceId,
  });
}

class AiHeritageService {
  static List<String> getSuggestedPrompts() {
    return [
      '👑 Plan a 3-Day Golden Triangle Heritage Itinerary',
      '🛕 Explain Nagara vs Dravidian Temple Architecture',
      '🌟 Why is Hampi called the Stone Chariot City?',
      '🎨 Tell me about Krishnanagar clay dolls & Rajbari',
      '🕳️ What makes Kailash Temple at Ellora an engineering miracle?',
      '🌊 Why are there 84 Ghats in Varanasi?',
    ];
  }

  static Future<AiMessage> getResponse(String userQuery) async {
    // Simulate natural AI thinking delay
    await Future.delayed(const Duration(milliseconds: 650));
    final lower = userQuery.toLowerCase();

    if (lower.contains('3-day') || lower.contains('itinerary') || lower.contains('golden triangle')) {
      return AiMessage(
        text: '🚩 **Curated 3-Day Golden Triangle Heritage Tour:**\n\n'
            '• **Day 1: Delhi — Imperial Capital**\n'
            '  - Morning: Explore the 73m Qutub Minar & 1,600-year-old rust-resistant Gupta Iron Pillar.\n'
            '  - Afternoon: Red Fort & Humayun\'s Tomb.\n'
            '  - Evening: Savor Mughlai culinary heritage in Chandni Chowk.\n\n'
            '• **Day 2: Agra — Realm of Mughal Marvels**\n'
            '  - Sunrise: Marvel at the white Makrana marble and pietra dura inlays of the Taj Mahal.\n'
            '  - Afternoon: Agra Fort Jahangiri Mahal and Diwan-i-Khas.\n'
            '  - Evening: Sunset view of Taj Mahal from Mehtab Bagh across the Yamuna.\n\n'
            '• **Day 3: Jaipur — The Pink City of Forts**\n'
            '  - Morning: Elephant ramparts and Sheesh Mahal at Amber Fort.\n'
            '  - Afternoon: Hawa Mahal facade and Jantar Mantar astronomical instruments.\n'
            '  - Evening: Chokhi Dhani cultural folk dance & Dal Baati Churma feast.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'taj-mahal',
      );
    }

    if (lower.contains('nagara') || lower.contains('dravidian') || lower.contains('architecture')) {
      return AiMessage(
        text: '🏛️ **Nagara vs Dravidian Temple Architecture Styles:**\n\n'
            '1. **Nagara Style (North & Central India):**\n'
            '  • *Curvilinear Shikhara*: Tall beehive-shaped tapering tower over the Garbhagriha.\n'
            '  • *No Monumental Boundary Walls*: Open plinth structure with Amalaka (stone disc) and Kalasha at summit.\n'
            '  • *Examples*: Khajuraho Kandariya Mahadeva, Konark Sun Temple, Somnath.\n\n'
            '2. **Dravidian Style (South India):**\n'
            '  • *Pyramidal Vimana & Gopurams*: Stepped pyramid tower over sanctum with monumental entrance gateway towers (Gopurams).\n'
            '  • *Enclosed Courtyards*: Expansive concentric stone prakaras with 1,000-pillar mandapas and sacred temple water tanks (Pushkarani).\n'
            '  • *Examples*: Brihadisvara Temple (Thanjavur), Meenakshi Amman (Madurai).\n\n'
            '3. **Vesara Style (Deccan):** A harmonious hybrid seen in Badami and Hoysala Belur temples!',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'brihadisvara-temple',
      );
    }

    if (lower.contains('hampi') || lower.contains('chariot') || lower.contains('vijayanagara')) {
      return AiMessage(
        text: '🛕 **Hampi — The City of Victory & Monolithic Wonders:**\n\n'
            '• Hampi was the capital of the Vijayanagara Empire (1336–1565 CE), once the 2nd largest medieval metropolis in the world after Beijing!\n'
            '• **Stone Chariot**: Dedicated to Garuda, the vehicle of Lord Vishnu. The wheels were carved to actually rotate on stone axles.\n'
            '• **Musical Pillars**: The 56 pillars of the Ranga Mandapa emit acoustic frequencies resembling classical Indian musical instruments (Mrigangam, Veena, Flute).\n'
            '• Featured on the reverse of the Indian ₹50 banknote.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'hampi-ruins',
      );
    }

    if (lower.contains('ellora') || lower.contains('kailash') || lower.contains('caves') || lower.contains('ajanta')) {
      return AiMessage(
        text: '🗿 **The Miracle of Kailash Temple (Ellora Cave 16):**\n\n'
            '• **Top-Down Excavation**: Unlike normal construction, Rashtrakuta artisans carved downwards through solid volcanic basalt cliff without scaffolding.\n'
            '• **Monumental Feat**: An estimated 200,000 to 400,000 tonnes of rock were excavated with just chisels and hammers in the 8th century CE under King Krishna I.\n'
            '• **Two-Storey Monolithic Complex**: Features full-size carved elephants, 100-foot victory flagstaffs (Dhvajastambhas), and multi-tiered galleries that replicate Lord Shiva\'s Himalayan abode.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'ajanta-caves',
      );
    }

    if (lower.contains('krishnanagar') || lower.contains('clay') || lower.contains('rajbari') || lower.contains('gopal bhar')) {
      return AiMessage(
        text: '👑 **Krishnanagar Rajbari & Ghurni Clay Art:**\n\n'
            '• **Maharaja Krishna Chandra Ray (18th Century)** was one of Bengal\'s greatest patrons of culture, pioneering the grand public worship of Goddess Jagaddhatri.\n'
            '• **Gopal Bhar**: The legendary quick-witted courtier whose humorous parables and wisdom defined Bengali folklore.\n'
            '• **Ghurni Clay Art**: Master artisans use fine clay from the Jalangi river to create hyper-realistic figurines that won global acclaim at the 1851 Great Exhibition of London.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'krishnanagar-rajbari',
      );
    }

    if (lower.contains('varanasi') || lower.contains('kashi') || lower.contains('ghats')) {
      return AiMessage(
        text: '🌊 **Varanasi — The Eternal Light of Kashi:**\n\n'
            '• Varanasi features **84 stone ghats** lining the crescent curve of the sacred Ganges River.\n'
            '• **Dashashwamedh Ghat**: The most famous ghat where Brahma performed the ten-horse sacrifice. Venue for the hypnotic evening Ganga Aarti.\n'
            '• **Manikarnika Ghat**: The primary burning ghat where sacred cremation fires have burned continuously for over 3,000 years, symbolising liberation (Moksha).\n'
            '• **Weaving Heritage**: Renowned worldwide for pure Katan silk sarees with real gold and silver Zari brocade.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'varanasi-ghats',
      );
    }

    // Default rich intelligent cultural answer
    return AiMessage(
      text: 'Namaste! 🙏 In Indian heritage, **"$userQuery"** connects to a rich tapestry of history, art, and cultural traditions.\n\n'
          'India is home to 42 UNESCO World Heritage Sites spanning ancient rock-cut caves, medieval temple citadels, royal hill forts, and sacred riverfronts.\n\n'
          '💡 *Tip: You can ask me to plan a custom travel itinerary, compare architectural dynasties (Chola, Mughal, Rajput, Gupta), or explore audio guide narrations for any monument!*',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
