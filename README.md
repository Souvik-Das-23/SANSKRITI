# 🛕 Sanskriti — Discover India's Rich Heritage

[![MIT License](https://img.shields.io/badge/License-MIT-gold.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Theme](https://img.shields.io/badge/Theme-Obsidian_%26_Imperial_Gold-D4AF37)](https://github.com/Souvik-Das-23/SANSKRITI)

A modern, royal digital platform for exploring India's historical monuments, cultural destinations, vibrant festivals, authentic artisan handicrafts, interactive audio guides, and AI-powered heritage wisdom.

---

## 📖 About Sanskriti

**Sanskriti** is a modern Flutter-based cultural tourism application designed to make India's rich historical and cultural heritage easier to discover, learn about, and explore.

The application combines an elegant **dark-and-gold visual experience** with interactive **Heritage Radar maps**, categorized heritage destinations, in-depth historical and architectural chronicles, audio tours, festival calendars, and craft artisan commerce.

From discovering ancient rock-cut caves and magnificent forts to finding nearby heritage locations and navigating directly to them with turn-by-turn Google Maps, Sanskriti creates a singular digital experience for cultural exploration.

---

## 🎯 Vision

> *« Connect people with India's heritage through technology. »*

Sanskriti focuses on making cultural tourism more accessible, engaging, and technology-driven while encouraging users to explore India's diverse historical and regional identity.

---

## ✨ Key Features

### 🗺️ Heritage Radar & Live Discovery
- **Interactive Dark Map Engine**: Powered by `flutter_map` and high-performance CartoDB Dark Matter tile architecture.
- **Custom Categorized Markers**: Color-coded glyph pins for Temples (Gold), Forts (Crimson), Caves (Emerald), Palaces (Sapphire), and Sacred Ghats (Cyan).
- **Live GPS Proximity Sorting**: Real-time distance computation from user coordinates with proximity radius filters (*Within 15 km, 50 km, 250 km, All India*).
- **1-Tap Turn-by-Turn Navigation**: Direct handoff to native Google Maps driving mode.

### 🏛️ Heritage Exploration & Catalog
- **Categorized Discovery**:
  - 🛕 **Temples**: Konark Sun Temple, Brihadisvara, Meenakshi Amman, Mayapur Chandrodaya Mandir, Khajuraho.
  - 🏰 **Forts**: Amber Fort, Jaisalmer Golden Fort, Golconda.
  - 🗿 **Monuments**: Taj Mahal, Hampi Vijayanagara Ruins, Qutub Minar, Victoria Memorial.
  - 🕳️ **Ancient Caves**: Ajanta & Ellora (Kailash Monolith).
  - 🏯 **Royal Palaces**: Krishnanagar Rajbari, City Palace.
  - 🌊 **Sacred Ghats**: Varanasi Dashashwamedh & Manikarnika Ghats.
- **State & Region Filtering**: Instant filtering across West Bengal, Rajasthan, Uttar Pradesh, Karnataka, Maharashtra, Tamil Nadu, Odisha, Delhi, and Madhya Pradesh.
- **Royal Masonry Grid**: Dynamic staggered cards with UNESCO World Heritage badges, bookmarks, and live distance indicators.

### 📖 Immersive Place Details
- **Parallax Hero Banner**: High-definition monument imagery with UNESCO accreditation badges and quick stats.
- **Historical & Architectural Chronicles**: Deep storytelling covering dynastic patronage (Cholas, Mughals, Guptas, Rajputs, Nayakas, Senas), built eras, and engineering marvels.
- **Built-in Audio Guide Player**: Interactive player with audio waveform, progress slider, 10-second rewind/forward, speed controls (1.0x - 1.5x), and multi-lingual narration transcripts (*English, Hindi, Bengali, Sanskrit*).
- **Virtual Photo Gallery**: High-resolution zoomable architectural photograph gallery.
- **Travel & Visit Guide**: Best seasons to visit, operating hours, ticket fees, and nearby heritage circuits.

### 🎭 Cultural Services Hub
- 🎉 **Festival Calendar 2026**: Interactive celebration timeline with ritual breakdowns, countdowns, festive delicacies (Bhog), and notification reminders (*Durga Puja, Jagaddhatri Puja, Diwali, Dev Deepawali, Hampi Utsav, Pushkar Fair, Jagannath Ratha Yatra*).
- 🎟️ **Heritage Monument Passes**: Instant digital entry pass booking simulator with date and time-slot selectors, adult/child steppers, and generated confirmed digital QR passes.
- 🛍️ **Kala Bazaar (Artisans & Handicrafts)**: Discover verified GI-tagged Indian crafts (*Krishnanagar Clay Dolls, Kashmiri Pashmina, Varanasi Katan Silk, Jaipur Blue Pottery, Bastar Dhokra, Tanjore Gold Paintings*) with artisan guild connections.
- 🤖 **Veda Cultural AI Assistant**: Conversational AI guide with historical knowledge base, temple architecture comparative analysis (Nagara vs Dravidian), and 3-day travel itinerary planners.
- 📜 **Heritage Trivia Quiz**: Interactive multi-question quiz testing cultural knowledge with scoring and "Royal Heritage Scholar" badges.
- 🚨 **Off-Grid SOS & Pilgrim Safety Beacon**: Simulated BLE mesh beacon broadcasting user coordinates with direct emergency dialers (*112 Police, 1363 Tourist Helpline*).

---

## 🎨 Royal Visual Experience

Sanskriti follows a distinctive visual identity inspired by India's imperial architecture and ancient manuscripts:

- 🌑 **Obsidian Dark Foundation**: `#0C0C10` & `#14141C`
- 🟡 **Signature Imperial Gold Accents**: `#D4AF37`, `#F5E6C8`, `#FFDF73`
- 🏛️ **Regal Typography**: *Cinzel*, *Marcellus*, *Rozha One*, and *Outfit* via Google Fonts
- ✨ **Glassmorphism & Gold Gradients**: Intricate borders, subtle golden glow effects, and responsive card micro-animations

---

## 📸 App Preview

| Home & Discover | Heritage Radar Map | Place Details |
| :---: | :---: | :---: |
| *(Staggered Masonry Grid)* | *(Interactive Dark Map & Radar)* | *(Parallax Hero & Chronicles)* |

| Cultural Services Hub | Festival Calendar | Kala Bazaar Crafts |
| :---: | :---: | :---: |
| *(Services Ecosystem)* | *(Festive Timeline & Delicacies)* | *(GI-Tagged Artisan Showcase)* |

---

## 🛠️ Tech Stack & Architecture

```
sanskriti/
├── android/
├── ios/
├── lib/
│   ├── main.dart                      # Application entrypoint & theme setup
│   ├── app_theme.dart                 # Royal Obsidian & Gold Design System
│   ├── models/
│   │   ├── heritage_place.dart        # Heritage monument data structure
│   │   ├── festival.dart              # Cultural festival data model
│   │   ├── craft_item.dart            # Kala Bazaar craft & artisan model
│   │   ├── ticket_booking.dart        # Digital monument pass model
│   │   └── quiz_question.dart         # Heritage trivia question model
│   ├── data/
│   │   ├── heritage_repository.dart   # 14+ curated Indian monuments repository
│   │   ├── festival_repository.dart   # Major Indian festivals repository
│   │   ├── kala_bazaar_repository.dart# GI-tagged handicrafts repository
│   │   └── quiz_repository.dart       # Trivia questions repository
│   ├── services/
│   │   ├── location_service.dart      # Geolocator, distance calculations & navigation
│   │   ├── audio_service.dart         # Audio tour guide state manager & ambient sounds
│   │   ├── ai_heritage_service.dart   # Veda AI conversational cultural guide
│   │   └── favorites_service.dart     # Bookmarks and reminder state management
│   ├── screens/
│   │   ├── splash_screen.dart         # Royal animated splash screen with shloka
│   │   ├── main_navigation.dart       # 5-tab navigation bar with floating SOS beacon
│   │   ├── home_screen.dart           # Discover page with spotlight & masonry grid
│   │   ├── details_screen.dart        # Deep chronicle, audio tour & architecture tabs
│   │   ├── map_screen.dart            # Heritage Radar interactive dark map
│   │   ├── services_screen.dart       # Cultural services hub
│   │   ├── festival_calendar_screen.dart # Festive timeline with traditions & food
│   │   ├── kala_bazaar_screen.dart    # Artisan craft discovery & contact modal
│   │   ├── ticket_booking_screen.dart # E-Pass generator with simulated QR codes
│   │   ├── ai_assistant_screen.dart   # Veda AI chat interface with preset prompts
│   │   ├── quiz_screen.dart           # Interactive heritage trivia game
│   │   └── favorites_screen.dart      # Saved monuments & active festival alerts
│   └── widgets/
│       ├── heritage_card.dart         # Reusable masonry monument card
│       ├── audio_guide_bottom_sheet.dart # Royal audio player bottom sheet
│       └── sos_dialog.dart            # Off-Grid SOS emergency beacon dialog
└── test/
    └── widget_test.dart               # Complete unit & widget test suite (10/10 passed)
```

---

## 🚀 Getting Started

### 📋 Prerequisites
- **Flutter SDK**: `>= 3.0.0 < 4.0.0`
- **Dart SDK**: Compatible with Flutter SDK
- Android Studio / VS Code with Flutter extension
- An Android Device or Emulator

### 📥 1. Clone the Repository
```bash
git clone https://github.com/Souvik-Das-23/SANSKRITI.git
cd SANSKRITI/sanskriti
```

### 📦 2. Install Dependencies
```bash
flutter pub get
```

### ▶️ 3. Run the Application
```bash
flutter run
```

### 🧪 4. Run Automated Tests
```bash
flutter test
```

---

## 🧭 Application Flow

```
┌─────────────────────────────────┐
│        Sanskriti App            │
│  (Animated Royal Splash Screen) │
└────────────────┬────────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│         Main Navigation         │
│  (5 Tabs + Floating SOS Beacon) │
└───────┬───┬───┬───┬─────────────┘
        │   │   │   │
  ┌─────┘   │   │   └──────────────────────┐
  ▼         ▼   ▼                          ▼
┌─────────┐ ┌─────────┐ ┌──────────────┐ ┌─────────────┐ ┌──────────────┐
│  Home   │ │  Radar  │ │   Services   │ │ Kala Bazaar │ │   Veda AI    │
│Discover │ │  (Map)  │ │     Hub      │ │ (Artisans)  │ │ (Assistant)  │
└────┬────┘ └───┬─────┘ └──────┬───────┘ └─────────────┘ └──────────────┘
     │          │              │
     │          │        ┌─────┴────────────────────────────┐
     │          │        ▼                                  ▼
     │          │  ┌───────────┐ ┌──────────────┐    ┌─────────────┐
     │          │  │ Festival  │ │ Ticket Pass  │    │ Heritage    │
     │          │  │ Calendar  │ │  Booking & QR│    │ Trivia Quiz │
     │          │  └───────────┘ └──────────────┘    └─────────────┘
     ▼          ▼
┌───────────────────────┐
│  Place Details Screen │
│  - Historical Saga    │
│  - Architecture Marvel│
│  - Audio Guide Player │
│  - Photo Gallery      │
│  - 1-Tap Navigation   │
└───────────────────────┘
```

---

## 🌍 Future Roadmap

- 🔐 Cloud User Authentication & Profile Synchronization
- 🎧 True Offline Audio Caching for Remote Archaeological Sites
- 🥽 Augmented Reality (AR) Monument Restoration Overlays
- 🌐 Multilingual Voice Synthesis for Audio Guides
- 🎫 Live Payment Gateway Integration for ASI Monuments & Temple Darshans

---

## 👨‍💻 Author

**Souvik Das**  
*Flutter & Full-Stack Developer*  
- GitHub: [@Souvik-Das-23](https://github.com/Souvik-Das-23)
- Repository: [Souvik-Das-23/SANSKRITI](https://github.com/Souvik-Das-23/SANSKRITI)

---

## 📄 License

This project is open-source and licensed under the [MIT License](LICENSE).
