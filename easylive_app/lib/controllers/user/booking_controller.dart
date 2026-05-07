import '../../models/user/booking_model.dart';

class BookingController {
  static const List<String> bookingStatuses = ['Active', 'Completed', 'Canceled'];

  static final List<Booking> allBookings = [
    Booking(
      title: 'Kost Melati',
      location: 'Cengger Ayam',
      price: 'Rp 650.000',
      type: 'Kost',
      status: 'Active',
    ),
    Booking(
      title: 'Laundry Express',
      location: 'Lowokwaru',
      price: 'Rp 35.000',
      type: 'Jasa',
      status: 'Completed',
    ),
  ];

  static List<Booking> getFilteredBookings(
    String type,
    String status,
    String searchQuery,
  ) {
    return allBookings.where((booking) {
      String checkStatus = status == 'Active Now' ? 'Active' : status;
      final matchesType = booking.type == type;
      final matchesStatus = booking.status == checkStatus;
      final matchesSearch = searchQuery.isEmpty ||
          booking.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          booking.location.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesStatus && matchesSearch;
    }).toList();
  }

  static String getEmptyMessage(String status) {
    switch (status) {
      case 'Completed':
        return 'You have no completed booking';
      case 'Canceled':
        return 'You have no canceled booking';
      default:
        return 'You have no active booking';
    }
  }
}
