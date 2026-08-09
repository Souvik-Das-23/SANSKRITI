// lib/data/mock_data.dart
// lib/data/mock_data.dart

class MockData {
  static const List<String> categories = ['All', 'Temples', 'Forts', 'Caves', 'Monuments'];

  // 1. Home Screen Data (Places)
  static const List<Map<String, dynamic>> places = [
    {
      'name': 'Taj Mahal',
      'location': 'Agra, UP',
      'image': 'https://images.unsplash.com/photo-1564507592208-52845649e523?q=80&w=800&auto=format&fit=crop', 
      'height': 250.0, 
    },
    {
      'name': 'Hampi Ruins',
      'location': 'Karnataka',
      'image': 'https://images.unsplash.com/photo-1600011689027-0c6a5124b89b?q=80&w=800&auto=format&fit=crop',
      'height': 180.0,
    },
    {
      'name': 'Ajanta Caves',
      'location': 'Maharashtra',
      'image': 'https://images.unsplash.com/photo-1622308643241-76675083c072?q=80&w=800&auto=format&fit=crop',
      'height': 220.0,
    },
    {
      'name': 'Amber Fort',
      'location': 'Rajasthan',
      'image': 'https://images.unsplash.com/photo-1599661555350-53bc77085794?q=80&w=800&auto=format&fit=crop',
      'height': 200.0,
    },
  ];

  // 2. Map Screen Data (Live Location Demo)
  static const Map<String, double> userLocation = {'lat': 28.6139, 'lng': 77.2090};

  static const List<Map<String, dynamic>> nearbyPlaces = [
    {
      'name': 'India Gate',
      'lat': 28.6129,
      'lng': 77.2295,
      'image': 'https://images.unsplash.com/photo-1587474260580-5a3c26d70549?q=80&w=500&auto=format&fit=crop',
      'distance': '2.1 km',
    },
    {
      'name': 'Red Fort',
      'lat': 28.6562,
      'lng': 77.2410,
      'image': 'https://images.unsplash.com/photo-1585084335487-f659d098f52f?q=80&w=500&auto=format&fit=crop',
      'distance': '5.4 km',
    },
  ];

  // 3. Festival Calendar Data
  static const List<Map<String, dynamic>> festivals = [
    {
      'name': 'Durga Puja',
      'date': 'Oct 2026',
      'region': 'West Bengal & East India',
      'image': 'https://images.unsplash.com/photo-1572013343866-2f0c7eb167db?q=80&w=600&auto=format&fit=crop',
      'significance': 'Celebrates the victory of Goddess Durga over the demon king Mahishasura.',
      'food': 'Bhog (Khichuri, Labra), Roshogolla',
    },
    {
      'name': 'Diwali',
      'date': 'Nov 2026',
      'region': 'Pan India',
      'image': 'https://images.unsplash.com/photo-1572445271230-a78b595f9c43?q=80&w=600&auto=format&fit=crop',
      'significance': 'The festival of lights, marking the victory of light over darkness.',
      'food': 'Kaju Katli, Samosa, Ladoo',
    },
  ];
}