// lib/screens/festival_calendar_screen.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';

class FestivalCalendarScreen extends StatelessWidget {
  const FestivalCalendarScreen({super.key});

  // 🌟 MOCK DATA FOR HACKATHON 🌟
  final List<Map<String, String>> _festivals = const [
    {
      'name': 'Durga Puja',
      'date': '09 - 13 October',
      'location': 'All over Bengal',
      'description': 'The grandest festival celebrating Goddess Durga.',
      'image': 'https://images.unsplash.com/photo-1601058268499-e52658b8bb88?q=80&w=800&auto=format&fit=crop',
    },
    {
      'name': 'Jagaddhatri Puja',
      'date': '10 - 12 November',
      'location': 'Krishnanagar & Chandannagar',
      'description': 'Famous for its massive idols and spectacular lightings.',
      'image': 'https://images.unsplash.com/photo-1583089892943-e02e5ee6beec?q=80&w=800&auto=format&fit=crop',
    },
    {
      'name': 'Rash Mela',
      'date': '27 November',
      'location': 'Nabadwip & Cooch Behar',
      'description': 'A historic month-long fair celebrating Lord Krishna.',
      'image': 'https://images.unsplash.com/photo-1574359411659-15573a27fd0c?q=80&w=800&auto=format&fit=crop',
    },
    {
      'name': 'Poush Mela',
      'date': '24 - 26 December',
      'location': 'Santiniketan',
      'description': 'Annual fair and festival marking the harvest season.',
      'image': 'https://images.unsplash.com/photo-1514222134-b57ec4d56d2f?q=80&w=800&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: const Text("Festival Calendar", style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppTheme.accentGold),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _festivals.length,
        itemBuilder: (context, index) {
          final festival = _festivals[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: Image.network(
                    festival['image']!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              festival['name']!,
                              style: const TextStyle(color: AppTheme.accentGold, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              festival['date']!,
                              style: const TextStyle(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.textMuted, size: 16),
                          const SizedBox(width: 4),
                          Text(festival['location']!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        festival['description']!,
                        style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}