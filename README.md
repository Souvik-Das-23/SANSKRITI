🛕 Sanskriti — Discover India's Rich Heritage

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-2.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Google%20Maps-API-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white" alt="Google Maps">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android">
</p><p align="center">
  <strong>A modern digital platform for exploring India's historical monuments, cultural destinations, festivals, and regional heritage.</strong>
</p>---

📖 About Sanskriti

Sanskriti is a modern Flutter-based cultural tourism application designed to make India's rich historical and cultural heritage easier to discover and explore.

The application combines an elegant dark-and-gold visual experience with interactive maps, categorized heritage destinations, detailed historical information, and cultural services.

From discovering ancient temples and magnificent forts to finding nearby heritage locations and navigating directly to them, Sanskriti aims to create a single digital experience for cultural exploration.

🎯 Vision

«Connect people with India's heritage through technology.»

Sanskriti focuses on making cultural tourism more accessible, engaging, and technology-driven while encouraging users to explore India's diverse historical and regional identity.

---

✨ Key Features

🗺️ Heritage Radar

Explore heritage destinations through an interactive Google Maps interface.

- 📍 Custom heritage markers
- 📏 Live distance calculation
- 🧭 Location-based discovery
- 🚗 Turn-by-turn navigation support
- 🗺️ Interactive map experience

---

🏛️ Heritage Exploration

Discover India's cultural landmarks through a visually rich exploration interface.

- 🛕 Temples
- 🏰 Forts
- 🗿 Historical monuments
- 🕳️ Ancient caves
- 🏯 Heritage structures
- 📚 Categorized exploration

---

📖 Place Details

Each heritage destination has a dedicated information page containing relevant historical and travel information.

- Historical background
- Location information
- Distance from the user
- Navigation action
- Heritage category
- Visual presentation

---

🎭 Cultural Services

Sanskriti brings useful cultural-tourism services together in one place.

Service| Description
🎉 Festival Calendar| Discover cultural festivals and events
🎟️ Heritage Tickets| Quick access to heritage ticket information
🎧 Audio Guides| Explore destinations through audio-based guidance
🛍️ Kala Bazaar| Discover local handicrafts and cultural products

---

🎨 Royal Visual Experience

Sanskriti follows a distinctive visual identity inspired by India's cultural heritage.

Design characteristics:

- 🌑 Dark UI
- 🟡 Signature Gold Accent — "#D4AF37"
- ✨ Modern card-based interface
- 🏛️ Heritage-inspired visual language
- 📱 Mobile-first responsive experience
- 🎯 Simple and intuitive navigation

---

📸 App Preview

Home Screen| Place Details
<img src="screenshots/home.png" width="250" alt="Sanskriti Home Screen">| <img src="screenshots/details.png" width="250" alt="Sanskriti Place Details">

Heritage Radar| Cultural Services
<img src="screenshots/map.png" width="250" alt="Sanskriti Heritage Radar">| <img src="screenshots/services.png" width="250" alt="Sanskriti Services Hub">

«Note: Make sure the corresponding images are available inside the "screenshots/" directory before pushing the README.»

---

🛠️ Tech Stack

Frontend

- Flutter
- Dart
- Material Design
- Custom Flutter UI components

APIs & Services

- Google Maps
- Geolocation
- External navigation
- URL launching

Flutter Packages

Package| Purpose
"google_maps_flutter"| Interactive Google Maps
"geolocator"| Location and distance calculation
"url_launcher"| External navigation and links

---

🏗️ Project Architecture

Sanskriti follows a modular Flutter project structure to keep the application maintainable and scalable.

sanskriti/
│
├── android/
├── ios/
│
├── lib/
│   ├── main.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── details_screen.dart
│   │   ├── map_screen.dart
│   │   └── services_screen.dart
│   │
│   ├── widgets/
│   │   └── reusable_widgets.dart
│   │
│   ├── models/
│   │   └── heritage_place.dart
│   │
│   ├── themes/
│   │   └── app_theme.dart
│   │
│   └── navigation/
│       └── app_navigation.dart
│
├── assets/
│   ├── images/
│   └── icons/
│
├── screenshots/
│   ├── home.png
│   ├── details.png
│   ├── map.png
│   └── services.png
│
├── pubspec.yaml
└── README.md

---

🚀 Getting Started

Follow the steps below to run Sanskriti locally.

📋 Prerequisites

Make sure you have the following installed:

- "Flutter SDK" (https://flutter.dev/)
- Dart SDK
- Android Studio or VS Code
- Android SDK
- A physical Android device or Android Emulator
- Google Cloud Platform account
- Google Maps API Key

---

📥 1. Clone the Repository

git clone https://github.com/your-username/sanskriti.git

Navigate into the project:

cd sanskriti

---

📦 2. Install Dependencies

Run:

flutter pub get

---

🗺️ 3. Configure Google Maps API

Sanskriti uses Google Maps for the Heritage Radar feature.

Step 1

Create or open a project in Google Cloud Console.

Step 2

Enable:

- Maps SDK for Android
- Geocoding API, if required
- Any additional Google Maps services used by your implementation

Step 3

Create an API key.

Step 4

Add your API key to:

android/app/src/main/AndroidManifest.xml

Example:

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>

«⚠️ Never commit unrestricted API keys to a public GitHub repository. Use appropriate API restrictions and protect sensitive credentials.»

---

📍 4. Configure Location Permissions

For Android, ensure location permissions are configured in:

android/app/src/main/AndroidManifest.xml

Example:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

Make sure your application requests runtime location permission where required.

---

▶️ 5. Run the Application

Check connected devices:

flutter devices

Then run:

flutter run

For a release build:

flutter build apk --release

The generated APK can be found inside the Flutter build output directory.

---

🔐 Security

If you are publishing this project publicly, avoid committing:

- API keys
- Passwords
- Access tokens
- Private certificates
- Signing keys
- Environment secrets

For Google Maps, restrict your API key by:

- Application
- API
- Platform

This keeps your credentials from becoming an accidental donation to the internet.

---

🧭 Application Flow

                    ┌─────────────────┐
                    │     Sanskriti   │
                    │     App Start   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Home Screen   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌──────────┐   ┌───────────┐   ┌────────────┐
        │ Heritage │   │  Heritage │   │  Cultural  │
        │ Explore  │   │   Radar   │   │  Services  │
        └────┬─────┘   └─────┬─────┘   └────────────┘
             │               │
             ▼               ▼
        ┌──────────┐    ┌────────────┐
        │  Place   │    │  Nearby    │
        │ Details  │    │ Heritage   │
        └────┬─────┘    │ Locations  │
             │          └─────┬──────┘
             ▼                │
        ┌──────────┐          ▼
        │ Navigate │    ┌────────────┐
        │ to Place │    │ Navigation │
        └──────────┘    └────────────┘

---

🌍 Future Roadmap

Sanskriti is designed with future expansion in mind.

Planned Features

- [ ] 🔐 User authentication
- [ ] ❤️ Save favorite heritage locations
- [ ] ⭐ User reviews and ratings
- [ ] 🌐 Multi-language support
- [ ] 🎧 AI-powered audio guides
- [ ] 🤖 AI cultural assistant
- [ ] 📴 Offline heritage information
- [ ] 📅 Live festival updates
- [ ] 🎟️ Online ticket booking
- [ ] 🛍️ Integrated handicraft marketplace
- [ ] 🧭 Personalized travel recommendations
- [ ] 📍 Advanced location-based recommendations

---

💡 Why Sanskriti?

India has an enormous cultural and historical landscape, but discovering it can often require information from multiple disconnected sources.

Sanskriti aims to bring together:

Discover → Learn → Navigate → Experience

into one simple mobile platform.

The goal is not only to help users find places, but also to encourage deeper engagement with India's cultural heritage.

---

📊 Key Highlights

Category| Details
📱 Platform| Android
🧩 Framework| Flutter
💻 Language| Dart
🗺️ Maps| Google Maps
📍 Location| Geolocator
🎨 UI Theme| Dark + Gold
🏛️ Focus| Cultural Tourism
🧱 Architecture| Modular Flutter Architecture

---

🤝 Contributing

Contributions are welcome.

If you would like to improve Sanskriti:

1. Fork the repository
2. Create a feature branch

git checkout -b feature/new-feature

3. Make your changes
4. Commit your changes

git commit -m "Add new feature"

5. Push the branch

git push origin feature/new-feature

6. Open a Pull Request

---

📄 License

This project is currently available for educational and portfolio purposes.

If you plan to distribute Sanskriti commercially, add an appropriate open-source or proprietary license to the repository.

---

👨‍💻 Author

Souvik Das

BCA Student | Flutter & Web Developer

Technologies

"Flutter" · "Dart" · "Python" · "PHP" · "HTML" · "CSS" · "JavaScript"

---

⭐ Support

If you find Sanskriti interesting or useful, consider giving the repository a ⭐ on GitHub.

Every star helps the project get a little more visibility.

---

<p align="center">
  <strong>🛕 Sanskriti — Discover. Learn. Experience India's Heritage.</strong>
</p>
