// lib/models/ticket_booking.dart

class TicketBooking {
  final String passId;
  final String monumentName;
  final String monumentLocation;
  final String visitorName;
  final String visitorEmail;
  final String visitorPhone;
  final int adultCount;
  final int childCount;
  final DateTime visitDate;
  final String timeSlot;
  final double totalAmount;
  final String status;
  final DateTime bookedAt;

  TicketBooking({
    required this.passId,
    required this.monumentName,
    required this.monumentLocation,
    required this.visitorName,
    required this.visitorEmail,
    required this.visitorPhone,
    required this.adultCount,
    required this.childCount,
    required this.visitDate,
    required this.timeSlot,
    required this.totalAmount,
    this.status = 'Confirmed',
    required this.bookedAt,
  });
}
