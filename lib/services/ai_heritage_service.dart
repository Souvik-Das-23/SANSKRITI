// lib/services/ai_heritage_service.dart
import 'dart:async';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? placeReferenceId;
  final bool isScanResult;
  final Map<String, String>? scanMetadata;

  AiMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.placeReferenceId,
    this.isScanResult = false,
    this.scanMetadata,
  });
}

class AiHeritageService {
  static List<String> getSuggestedPrompts([String language = 'English']) {
    switch (language) {
      case 'Hindi':
        return [
          '🛕 नागर और द्रविड़ मंदिर वास्तुकला में क्या अंतर है?',
          '👑 3-दिवसीय स्वर्ण त्रिभुज (Golden Triangle) हेरिटेज यात्रा योजना बनाएं',
          '🌟 हम्पी का पत्थर का रथ क्यों प्रसिद्ध है?',
          '🎨 कृष्णनगर की मिट्टी की मूर्तियों की क्या विशेषता है?',
          '📜 एलोरा के कैलाश मंदिर का रहस्य क्या है?',
        ];
      case 'Bengali':
        return [
          '👑 কৃষ্ণনগর রাজবাড়ি ও ঘূর্ণির মাটির পুতুলের ইতিহাস কী?',
          '🛕 দ্রাবিড় ও নাগরা মন্দির স্থাপত্যের পার্থক্য কী?',
          '🌟 হাম্পির পাথরের রথ কেন বিখ্যাত?',
          '🌊 বারাণসীর ৮৪টি ঘাটের তাৎপর্য কী?',
        ];
      default:
        return [
          '👑 Plan a 3-Day Golden Triangle Heritage Itinerary',
          '🛕 Explain Nagara vs Dravidian Temple Architecture',
          '🌟 Why is Hampi called the Stone Chariot City?',
          '🎨 Tell me about Krishnanagar clay dolls & Rajbari',
          '🕳️ What makes Kailash Temple at Ellora an engineering miracle?',
          '🌊 Why are there 84 Ghats in Varanasi?',
          '🔍 Scan Heritage Artifact with AI Lens',
        ];
    }
  }

  static Future<AiMessage> getResponse(String userQuery, {String language = 'English'}) async {
    // Simulate natural AI thinking delay
    await Future.delayed(const Duration(milliseconds: 650));
    final lower = userQuery.toLowerCase();

    // 1. AI Heritage Lens Scan Queries
    if (lower.startsWith('scan:') || lower.contains('ai lens') || lower.contains('identify artifact')) {
      return _generateLensScanResult(userQuery);
    }

    // 2. Multilingual: Bengali
    if (language == 'Bengali' || lower.contains('কৃষ্ণনগর') || lower.contains('হাম্পি')) {
      if (lower.contains('কৃষ্ণনগর') || lower.contains('ঘূর্ণি') || lower.contains('রাজবাড়ি')) {
        return AiMessage(
          text: '👑 **কৃষ্ণনগর রাজবাড়ি ও ঘূর্ণির ঐতিহ্যবাহী মৃৎশিল্প:**\n\n'
              '• **মহারাজা কৃষ্ণচন্দ্র রায় (১৮শ শতক)**: বাংলার শিল্প ও সংস্কৃতির শ্রেষ্ঠ পৃষ্ঠপোষক, যিনি জগদ্ধাত্রী পূজার সূচনা করেন।\n'
              '• **গোপাল ভাঁড়**: কৃষ্ণচন্দ্র রায়ের রাজসভার প্রখ্যাত হাস্যরসিক যাঁর বুদ্ধিদীপ্ত কাহিনী আজও অমর।\n'
              '• **ঘূর্ণির মাটির পুতুল**: জলঙ্গী নদীর সূক্ষ্ম এঁটেল মাটি দিয়ে তৈরি বিশ্বখ্যাত ভৌগোলিক নির্দেশক (GI Tag) শিল্পকর্ম। ১৮৫১ সালের লন্ডনের গ্রেট এক্সিবিশনে এটি আন্তর্জাতিক সম্মান অর্জন করে।',
          isUser: false,
          timestamp: DateTime.now(),
          placeReferenceId: 'krishnanagar-rajbari',
        );
      }
      if (lower.contains('হাম্পি') || lower.contains('রথ')) {
        return AiMessage(
          text: '🛕 **হাম্পি — বিজয়নগর সাম্রাজ্যের বিস্ময়:**\n\n'
              '• চতুর্দশ শতকে প্রতিষ্ঠিত বিজয়নগর সাম্রাজ্যের রাজধানী।\n'
              '• **পাথরের রথ**: গরুড় দেবের প্রতি উৎসর্গীকৃত অখণ্ড গ্রানাইট পাথরের স্থাপত্য।\n'
              '• **সংগীত স্তম্ভ**: রঙ্গ মণ্ডপের ৫৬টি গ্রানাইট স্তম্ভে আঙুলের টোকায় ভারতীয় শাস্ত্রীয় বাদ্যযন্ত্রের ধ্বনি নির্গত হয়।',
          isUser: false,
          timestamp: DateTime.now(),
          placeReferenceId: 'hampi-ruins',
        );
      }
    }

    // 3. Multilingual: Hindi
    if (language == 'Hindi' || lower.contains('नागर') || lower.contains('द्रविड़')) {
      if (lower.contains('नागर') || lower.contains('द्रविड़') || lower.contains('वास्तुकला')) {
        return AiMessage(
          text: '🏛️ **नागर बनाम द्रविड़ मंदिर वास्तुकला शैली:**\n\n'
              '1. **नागर शैली (उत्तर एवं मध्य भारत):**\n'
              '  • गर्भगृह के ऊपर वक्राकार शिखर (मधुमक्खी के छत्ते जैसा आकार)।\n'
              '  • मुख्य शिखर के शीर्ष पर आमलक और कलश स्थापित होता है।\n'
              '  • *प्रमुख उदाहरण*: खजुराहो कंदरिया महादेव, कोणार्क सूर्य मंदिर, सोमनाथ।\n\n'
              '2. **द्रविड़ शैली (दक्षिण भारत):**\n'
              '  • सीढ़ीदार पिरामिडनुमा विमान एवं विशाल प्रवेश द्वार (गोपुरम)।\n'
              '  • 1000 स्तंभों वाले विशाल मंडप और पुष्करणी (कल्याण तीर्थ)।\n'
              '  • *प्रमुख उदाहरण*: तंजावुर बृहदीश्वर मंदिर, मीनाक्षी सुंदरेश्वर मंदिर।',
          isUser: false,
          timestamp: DateTime.now(),
          placeReferenceId: 'brihadisvara-temple',
        );
      }
    }

    // 4. English Itineraries & Dynastic Chronicles
    if (lower.contains('3-day') || lower.contains('itinerary') || lower.contains('golden triangle')) {
      return AiMessage(
        text: '🚩 **Curated 3-Day Golden Triangle Heritage Tour:**\n\n'
            '• **Day 1: Delhi — Imperial Dynastic Capital**\n'
            '  - Morning: Explore 73m Qutub Minar & 1,600-year-old rust-resistant Gupta Iron Pillar.\n'
            '  - Afternoon: Red Fort & Humayun\'s Tomb (Mughal garden tomb blueprint).\n'
            '  - Evening: Savor culinary traditions in Chandni Chowk.\n\n'
            '• **Day 2: Agra — Realm of Mughal Grandeur**\n'
            '  - Sunrise: Marvel at Makrana marble & Pietra Dura inlays of the Taj Mahal.\n'
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
            '  • *Open Plinth Structure*: Crowned with Amalaka (stone disc) and Kalasha.\n'
            '  • *Examples*: Khajuraho Kandariya Mahadeva, Konark Sun Temple, Somnath.\n\n'
            '2. **Dravidian Style (South India):**\n'
            '  • *Pyramidal Vimana & Gopurams*: Stepped pyramid tower over sanctum with monumental entrance towers (Gopurams).\n'
            '  • *Enclosed Courtyards*: Expansive concentric stone prakaras with 1,000-pillar mandapas and temple tanks (Pushkarani).\n'
            '  • *Examples*: Brihadisvara Temple (Thanjavur), Meenakshi Amman (Madurai).\n\n'
            '3. **Vesara Style (Deccan):** Harmonious synthesis seen in Badami Chalukya & Hoysala temples!',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'brihadisvara-temple',
      );
    }

    if (lower.contains('hampi') || lower.contains('chariot') || lower.contains('vijayanagara')) {
      return AiMessage(
        text: '🛕 **Hampi — The City of Victory & Monolithic Wonders:**\n\n'
            '• Capital of the Vijayanagara Empire (1336–1565 CE), once the 2nd largest medieval metropolis in the world after Beijing!\n'
            '• **Stone Chariot**: Dedicated to Garuda, the vehicle of Lord Vishnu. The carved granite wheels were engineered to rotate on stone axles.\n'
            '• **Musical Pillars**: 56 carved pillars of the Ranga Mandapa emit acoustic frequencies resembling classical Indian musical instruments (Mridangam, Veena, Flute).\n'
            '• Featured on the reverse of the Indian ₹50 banknote.',
        isUser: false,
        timestamp: DateTime.now(),
        placeReferenceId: 'hampi-ruins',
      );
    }

    if (lower.contains('ellora') || lower.contains('kailash') || lower.contains('caves') || lower.contains('ajanta')) {
      return AiMessage(
        text: '🗿 **The Miracle of Kailash Temple (Ellora Cave 16):**\n\n'
            '• **Top-Down Excavation**: Rashtrakuta artisans carved downwards through a solid volcanic basalt cliff without scaffolding.\n'
            '• **Monumental Feat**: An estimated 200,000 to 400,000 tonnes of rock were excavated with just chisels and hammers in the 8th century CE under King Krishna I.\n'
            '• **Monolithic Complex**: Features full-size carved elephants, 100-foot victory flagstaffs (Dhvajastambhas), and multi-tiered galleries replicating Lord Shiva\'s Himalayan abode.',
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
      text: 'Namaste! 🙏 In Indian heritage, **"$userQuery"** connects to a rich civilizational tapestry of history, philosophy, and architectural science.\n\n'
          'India is home to 42 UNESCO World Heritage Sites spanning ancient rock-cut caves, medieval temple citadels, royal hill forts, and sacred riverfronts.\n\n'
          '💡 *Tip: You can use the **AI Heritage Lens** to scan artifacts, request 3-Day itineraries, or switch languages (Hindi/Bengali/English)!*',
      isUser: false,
      timestamp: DateTime.now(),
    );
  }

  static AiMessage _generateLensScanResult(String userQuery) {
    final lower = userQuery.toLowerCase();

    if (lower.contains('nataraja') || lower.contains('bronze') || lower.contains('chola')) {
      return AiMessage(
        text: '🔍 **AI HERITAGE LENS: ARTIFACT IDENTIFIED**\n\n'
            '✨ **Object**: Chola Bronze Cosmic Dancer (Nataraja)\n'
            '👑 **Dynasty**: Imperial Chola Empire (10th–11th Century CE)\n'
            '📍 **Provenance**: Thanjavur / Swamimalai, Tamil Nadu\n'
            '🔬 **Casting Technique**: Madhuchishtavidhana (Lost-Wax / Cire Perdue method)\n\n'
            '📖 **Iconographical Symbolism:**\n'
            '• Upper Right Hand: Damaru (cosmic pulse of creation)\n'
            '• Upper Left Hand: Agni (sacred flame of cosmic dissolution)\n'
            '• Lower Right Hand: Abhaya Mudra (divine protection)\n'
            '• Trampled Figure: Apasmara Purusha (ignorance/illusion vanquished)\n'
            '• Surrounding Ring: Prabhamandala (the infinite cosmic cycle of time)',
        isUser: false,
        timestamp: DateTime.now(),
        isScanResult: true,
        scanMetadata: {
          'Confidence': '98.4%',
          'Dynasty': 'Imperial Chola',
          'Period': '10th Century CE',
          'Material': 'Panchaloha Bronze',
          'Status': 'National Treasure / ASI Grade A',
        },
      );
    }

    if (lower.contains('terracotta') || lower.contains('bankura') || lower.contains('bengal')) {
      return AiMessage(
        text: '🔍 **AI HERITAGE LENS: ARTIFACT IDENTIFIED**\n\n'
            '✨ **Object**: Bankura Terracotta Folk Horse (Panchmura)\n'
            '👑 **Dynasty / Tradition**: Malla Dynasty Folk Art of Rarh Bengal\n'
            '📍 **Provenance**: Panchmura Village, Bankura, West Bengal\n'
            '🏷️ **GI Status**: Certified Geographical Indication (GI Tag No. 83)\n\n'
            '📖 **Artisan Craft Details:**\n'
            '• Sculpted in 4 symmetrical hollow parts on a potter\'s wheel.\n'
            '• Fired in open rural earthen kilns at 800°C for terracotta rust-red patina.\n'
            '• Erect pointed ears and symmetrical leaf markings represent devotion to Lord Dharma Thakur.',
        isUser: false,
        timestamp: DateTime.now(),
        isScanResult: true,
        scanMetadata: {
          'Confidence': '96.8%',
          'Dynasty': 'Malla Realm Tradition',
          'Period': '17th Century to Present',
          'Material': 'Alluvial River Clay',
          'Status': 'GI-Tag Verified Fair Trade',
        },
      );
    }

    // Generic Scan Result for Indian Temple Sculpture / Monument
    return AiMessage(
      text: '🔍 **AI HERITAGE LENS: ARTIFACT IDENTIFIED**\n\n'
          '✨ **Classification**: Medieval Temple Rock-Cut Architectural Frieze\n'
          '🏛️ **Architectural Style**: Nagara / Vesara Transition Style\n'
          '📍 **Likely Region**: Central / Western India (11th–13th Century CE)\n'
          '🔬 **Material**: Carved Buff Sandstone\n\n'
          '📖 **Architectural Analysis:**\n'
          '• High-relief carving showing celestial apsaras and mythological motifs.\n'
          '• Demonstrates mastery of classical Shilpa Shastra proportions and deep undercutting.\n'
          '• Preserved under the Archaeological Survey of India (ASI) Antiquities Act.',
      isUser: false,
      timestamp: DateTime.now(),
      isScanResult: true,
      scanMetadata: {
        'Confidence': '94.2%',
        'Style': 'Nagara Architectural Sculpture',
        'Period': '12th Century CE',
        'Material': 'Carved Sandstone',
        'Status': 'ASI Protected Heritage',
      },
    );
  }
}
