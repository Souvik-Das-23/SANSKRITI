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
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = 'Morning (08:00 AM - 12:00 PM)';
  int _adultCount = 2;
  int _childCount = 0;
  final TextEditingController _nameController = TextEditingController(text: 'Souvik Das');
  final TextEditingController _emailController = TextEditingController(text: 'souvik@heritage.in');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98765 43210');

  final List<String> _timeSlots = [
    'Morning (08:00 AM - 12:00 PM)',
    'Afternoon (12:00 PM - 04:00 PM)',
    'Sunset Session (04:00 PM - 06:30 PM)',
  ];

  @override
  void initState() {
    super.initState();
    final allPlaces = HeritageRepository.getAllPlaces();
    _selectedPlace = widget.preSelectedPlace ?? allPlaces.first;
  }

  int get _ticketRate {
    if (_selectedPlace.entryFee.contains('₹50')) return 50;
    if (_selectedPlace.entryFee.contains('₹40')) return 40;
    if (_selectedPlace.entryFee.contains('₹25')) return 25;
    if (_selectedPlace.entryFee.contains('₹20')) return 20;
    return 50;
  }

  int get _totalAmount => (_adultCount * _ticketRate) + (_childCount * (_ticketRate ~/ 2));

  @override
  Widget build(BuildContext context) {
    final allPlaces = HeritageRepository.getAllPlaces();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('HERITAGE PASS BOOKING'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monument Selector
            Text('Select Heritage Monument', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.glassCardGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<HeritagePlace>(
                  value: _selectedPlace,
                  isExpanded: true,
                  dropdownColor: AppTheme.surfaceDark,
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.accentGold),
                  items: allPlaces.map((place) {
                    return DropdownMenuItem<HeritagePlace>(
                      value: place,
                      child: Text(
                        '${place.name} (${place.state})',
                        style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
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

            // Date Picker
            Text('Date of Visit', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
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
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.glassCardGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppTheme.accentGold, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                      style: GoogleFonts.outfit(color: AppTheme.accentGoldLight, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    const Text('Change', style: TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Slot Selector
            Text('Select Time Slot', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            const SizedBox(height: 8),
            ..._timeSlots.map((slot) {
              bool isSelected = _selectedSlot == slot;
              return GestureDetector(
                onTap: () => setState(() => _selectedSlot = slot),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentGold.withValues(alpha: 0.2) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.accentGold : Colors.white12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppTheme.accentGold : AppTheme.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        slot,
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.accentGoldLight : AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Visitor Count Stepper
            Text('Number of Visitors', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppTheme.glassCardGradient,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adults (Age 15+)', style: GoogleFonts.outfit(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('₹$_ticketRate per person', style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11)),
                        ],
                      ),
                      Row(
                        children: [
                          _buildStepperBtn(Icons.remove, () {
                            if (_adultCount > 1) setState(() => _adultCount--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text('$_adultCount', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGoldLight)),
                          ),
                          _buildStepperBtn(Icons.add, () => setState(() => _adultCount++)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Children (Under 15)', style: GoogleFonts.outfit(color: AppTheme.textLight, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('₹${_ticketRate ~/ 2} per child', style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11)),
                        ],
                      ),
                      Row(
                        children: [
                          _buildStepperBtn(Icons.remove, () {
                            if (_childCount > 0) setState(() => _childCount--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text('$_childCount', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGoldLight)),
                          ),
                          _buildStepperBtn(Icons.add, () => setState(() => _childCount++)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lead Visitor Info
            Text('Lead Visitor Details', style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            const SizedBox(height: 8),
            _buildInputField('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 10),
            _buildInputField('Email Address', _emailController, Icons.email_outlined),
            const SizedBox(height: 10),
            _buildInputField('Phone Number', _phoneController, Icons.phone_outlined),
            const SizedBox(height: 26),

            // Total & Book Button
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGlass,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL AMOUNT', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                      Text(
                        '₹$_totalAmount',
                        style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _showConfirmedTicketDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: AppTheme.backgroundDark,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('GENERATE E-PASS'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: AppTheme.accentGold, size: 16),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.accentGold, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  void _showConfirmedTicketDialog(BuildContext context) {
    final bookingId = 'SAN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.accentGold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGold.withValues(alpha: 0.25),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.goldGradient,
                  ),
                  child: const Icon(Icons.check, color: AppTheme.backgroundDark, size: 28),
                ),
                const SizedBox(height: 12),
                Text('OFFICIAL E-PASS ISSUED', style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGoldLight)),
                Text('Pass ID: $bookingId', style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted)),
                const Divider(color: Colors.white24, height: 24),
                // QR Mock
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.qr_code_2, size: 110, color: Colors.black),
                ),
                const SizedBox(height: 14),
                Text(_selectedPlace.name, style: GoogleFonts.marcellus(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGoldLight)),
                Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} • $_selectedSlot', textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted)),
                const SizedBox(height: 8),
                Text('Visitors: $_adultCount Adults, $_childCount Children • Total: ₹$_totalAmount', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('DOWNLOAD PASS'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
