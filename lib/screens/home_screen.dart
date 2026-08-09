// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../app_theme.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  void _showAIGuide(BuildContext context, String placeName) {
    final aiKnowledge = {
      'Taj Mahal': "✨ AI Fact: Taj Mahal din ke alag-alag samay mein apna rang badalta hua lagta hai!",
      'Hampi Ruins': "✨ AI Fact: Yahan ka 'Stone Chariot' architecture ka master-piece hai aur iske pahiye sach mein ghoom sakte the!",
      'Ajanta Caves': "✨ AI Fact: In gufaon ko pahadiyon ko kaat kar banaya gaya tha aur inme 2000 saal purani paintings hain!",
      'Amber Fort': "✨ AI Fact: Yahan ek 'Sheesh Mahal' hai jahan ek machis ki teeli jalane par poora mahal chamak uthta hai!"
    };

    final response = aiKnowledge[placeName] ?? "✨ AI Fact: Yeh India ke rich culture ka ek khoobsurat hissa hai!";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark, // Dark Popup Background
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: AppTheme.accentGold, blurRadius: 10, spreadRadius: -5)], // Golden Glow
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.accentGold),
                SizedBox(width: 10),
                Text("Sanskriti AI Guide", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
              ],
            ),
            const SizedBox(height: 15),
            Text("Analyzing $placeName...", style: const TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Text(response, style: const TextStyle(fontSize: 16, height: 1.5, color: AppTheme.textLight)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Discover India\'s', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18)),
              Text('Rich Heritage', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),

              // Dark & Golden Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: const TextStyle(color: AppTheme.textLight),
                  decoration: InputDecoration(
                    hintText: 'Search forts, temples...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: AppTheme.accentGold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dark & Golden Filter Chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.accentGold : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppTheme.accentGold : Colors.white24,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            MockData.categories[index],
                            style: TextStyle(
                              color: isSelected ? AppTheme.backgroundDark : AppTheme.textLight,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: MockData.places.length,
                  itemBuilder: (context, index) {
                    final place = MockData.places[index];
                    return _buildHeritageCard(place);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeritageCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () => _showAIGuide(context, place['name']), 
      child: Container(
        height: place['height'],
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(place['image']),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8), // Darker gradient for better text visibility
              ],
            ),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)), // Slight golden border
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place['name'],
                style: const TextStyle(color: AppTheme.accentGold, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(place['location'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}