// lib/screens/festival_screen.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../data/mock_data.dart';

class FestivalScreen extends StatelessWidget {
  const FestivalScreen({super.key});

  void _showFestivalDetails(BuildContext context, Map<String, dynamic> festival) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark, // Dark bottom sheet
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: AppTheme.accentGold, blurRadius: 10, spreadRadius: -5)],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: AppTheme.accentGold.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Text(festival['name'], style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.textMuted, size: 18),
                const SizedBox(width: 4),
                Text(festival['region'], style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: AppTheme.accentGold.withValues(alpha: 0.2)),
            const SizedBox(height: 10),
            Text('Significance', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(festival['significance'], style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text('Traditional Food', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: AppTheme.accentGold, size: 18),
                const SizedBox(width: 8),
                Text(festival['food'], style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('Cultural Calendar')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.festivals.length,
        itemBuilder: (context, index) {
          final festival = MockData.festivals[index];
          return GestureDetector(
            onTap: () => _showFestivalDetails(context, festival),
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Golden Timeline Date
                  SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        Text(
                          festival['date'].split(' ')[0], 
                          style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          festival['date'].split(' ')[1], 
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 2,
                          height: 100,
                          color: AppTheme.accentGold.withValues(alpha: 0.3), // Golden line
                        )
                      ],
                    ),
                  ),
                  // Dark Festival Card
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: NetworkImage(festival['image']), fit: BoxFit.cover),
                        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)], // Deep dark gradient
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              festival['name'],
                              style: const TextStyle(color: AppTheme.accentGold, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(festival['region'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}