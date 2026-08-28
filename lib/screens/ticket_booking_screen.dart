// lib/screens/ticket_booking_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/heritage_repository.dart';
import '../models/heritage_place.dart';

class TicketBookingScreen extends StatefulWidget {
  final HeritagePlace? preSelectedPlace;

  const TicketBookingScreen({super.key, this.preSelectedPlace});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  late HeritagePlace _selectedPlace;
  final _nameController = TextEditingController(text: 'Souvik Das');
  final _emailController = TextEditingController(text: 'souvik@heritage.in');
  final _phoneController = TextEditingController(text: '+91 98765 43210');

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = 'Morning (06:00 AM – 11:30 AM)';
  int _adultCount = 2;
  int _childCount = 0;
  final double _pricePerAdult = 50.0;
  final double _pricePerChild = 25.0;

  final List<String> _slots = [
    'Morning (06:00 AM – 11:30 AM)',
    'Afternoon (12:00 PM – 04:30 PM)',
    'Sunset & Light Show (05:00 PM – 08:30 PM)',
  ];

  @override
  void initState() {
    super.initState();
    final allPlaces = HeritageRepository.getAllPlaces();
    _selectedPlace = widget.preSelectedPlace ?? allPlaces.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  double get _totalPrice => (_adultCount * _pricePerAdult) + (_childCount * _pricePerChild);

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentGold,
              onPrimary: AppTheme.backgroundDark,
              surface: AppTheme.surfaceDark,
              onSurface: AppTheme.textLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _generateTicketPass() {
    final randomId = 'SKR-${Random().nextInt(900000) + 100000}';
    final dateStr = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.darkCardGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.accentGold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Golden Royal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance, color: AppTheme.accentGold, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'E-HERITAGE PASS',
                        style: GoogleFonts.cinzel(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Archaeological Survey of India & Sanskriti Digital Pass',
                    style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 10),
                  ),
                  const Divider(color: AppTheme.accentGold, height: 24, thickness: 1),

                  // Monument Name
                  Text(
                    _selectedPlace.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.marcellus(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGoldLight,
                    ),
                  ),
                  Text(
                    _selectedPlace.location,
                    style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Simulated QR Code Box
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGold, width: 2),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
                        Text(
                          randomId,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ticket Details Table
                  _buildTicketRow('Pass ID', randomId),
                  _buildTicketRow('Visitor Name', _nameController.text.trim()),
                  _buildTicketRow('Date of Visit', dateStr),
                  _buildTicketRow('Time Slot', _selectedSlot.split(' ')[0]),
                  _buildTicketRow('Visitors', '$_adultCount Adults, $_childCount Children'),
                  _buildTicketRow('Amount Paid', '₹${_totalPrice.toInt()} (Confirmed)'),
                  const SizedBox(height: 18),

                  // Verified Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.emeraldGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.emeraldGreen),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: AppTheme.emeraldGreen, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'CONFIRMED DIGITAL ENTRY PASS',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.emeraldGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('E-Heritage Pass saved to wallet successfully!'),
                                backgroundColor: AppTheme.accentGold,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text('SAVE PASS'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textMuted,
                            side: const BorderSide(color: Colors.white24),
                          ),
                          child: const Text('CLOSE'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted)),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allPlaces = HeritageRepository.getAllPlaces();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Heritage Monument Pass'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.darkCardGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                    ),
                    child: const Icon(Icons.confirmation_number, color: AppTheme.backgroundDark, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ASI Heritage Fast-Track Entry',
                          style: GoogleFonts.marcellus(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGoldLight,
                          ),
                        ),
                        Text(
                          'Skip ticket counter queues with instant QR code mobile passes.',
                          style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select Monument Dropdown
            Text(
              'Select Heritage Destination',
              style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<HeritagePlace>(
                  value: _selectedPlace,
                  isExpanded: true,
                  dropdownColor: AppTheme.surfaceDark,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accentGold),
                  items: allPlaces.map((place) {
                    return DropdownMenuItem<HeritagePlace>(
                      value: place,
                      child: Text(
                        '${place.name} (${place.location})',
                        style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPlace = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Visitor Contact Info
            Text(
              'Lead Visitor Details',
              style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: GoogleFonts.outfit(color: AppTheme.accentGold, fontSize: 12),
                      prefixIcon: const Icon(Icons.person, color: AppTheme.accentGold, size: 18),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: GoogleFonts.outfit(color: AppTheme.accentGold, fontSize: 12),
                            prefixIcon: const Icon(Icons.email, color: AppTheme.accentGold, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: GoogleFonts.outfit(color: AppTheme.accentGold, fontSize: 12),
                            prefixIcon: const Icon(Icons.phone, color: AppTheme.accentGold, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select Date & Slot
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit Date',
                        style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
                              ),
                              const Icon(Icons.calendar_today, color: AppTheme.accentGold, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Slot Selector
            Text(
              'Select Entry Slot',
              style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
            ),
            const SizedBox(height: 8),
            ..._slots.map((slot) {
              bool isSelected = _selectedSlot == slot;
              return GestureDetector(
                onTap: () => setState(() => _selectedSlot = slot),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentGold.withValues(alpha: 0.15) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.accentGold : Colors.white12,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        slot,
                        style: GoogleFonts.outfit(
                          color: isSelected ? AppTheme.accentGoldLight : AppTheme.textLight,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppTheme.accentGold : AppTheme.textMuted,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Visitors Stepper
            Text(
              'Number of Visitors',
              style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  // Adult Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adults (15+ yrs)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                          Text('₹50 per visitor', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.accentGold)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.accentGold),
                            onPressed: _adultCount > 1 ? () => setState(() => _adultCount--) : null,
                          ),
                          Text('$_adultCount', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.accentGold),
                            onPressed: () => setState(() => _adultCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12),
                  // Child Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Children (under 15 yrs)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                          Text('₹25 per child', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.accentGold)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.accentGold),
                            onPressed: _childCount > 0 ? () => setState(() => _childCount--) : null,
                          ),
                          Text('$_childCount', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.accentGold),
                            onPressed: () => setState(() => _childCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total Amount & Book Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount', style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textMuted)),
                      Text(
                        '₹${_totalPrice.toInt()}',
                        style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _generateTicketPass,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: const Text('GENERATE PASS'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
