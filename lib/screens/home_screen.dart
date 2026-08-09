// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section (Added 'const' for performance boost)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Namaste, Souvik! 🙏", 
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Explore Sanskriti", 
                        style: TextStyle(color: AppTheme.accentGold, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppTheme.surfaceDark,
                    radius: 24,
                    child: Icon(Icons.person, color: AppTheme.accentGold),
                  )
                ],
              ),
              
              const SizedBox(height: 30),

              // 2. 🌟 NAYA SERVICES SECTION 🌟
              const Text(
                "Our Services", 
                style: TextStyle(color: AppTheme.textLight, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Service 1: Festival Calendar
                  Expanded(
                    child: _buildServiceCard(
                      context,
                      title: "Festival\nCalendar",
                      icon: Icons.calendar_month,
                      onTap: () {
            
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Festival Calendar Opening Soon!"), 
                            backgroundColor: AppTheme.accentGold,
                          )
                        );
                      }
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Service 2: Booking Section
                  Expanded(
                    child: _buildServiceCard(
                      context,
                      title: "Heritage\nBooking",
                      icon: Icons.book_online,
                      onTap: () {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Booking Section Opening Soon!"), 
                            backgroundColor: AppTheme.accentGold,
                          )
                        );
                      }
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 3. Optional Banner
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1514222134-b57ec4d56d2f?q=80&w=800&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    "Discover Bengal's\nHidden Heritage",
                    style: TextStyle(color: AppTheme.accentGold, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }

  // 🛠️ Service Card Banane ka Custom Widget
  Widget _buildServiceCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
              ),
              child: Icon(icon, color: AppTheme.accentGold, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textLight, 
                fontWeight: FontWeight.bold, 
                fontSize: 14
              ),
            ),
          ],
        ),
      ),
    );
  }
}