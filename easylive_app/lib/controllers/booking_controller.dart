import '../models/booking_model.dart';

class BookingController {
<<<<<<< HEAD
=======
<<<<<<< Updated upstream
  List<Booking> allBookings = [
    Booking(title: "Kost Melati", location: "Cengger Ayam", price: "Rp 650.000", status: "Active"),
=======
>>>>>>> ailsa
  static const List<String> bookingStatuses = ['Active', 'Completed', 'Canceled'];

  final List<Booking> allBookings = [
    Booking(
      title: 'Kost Melati',
      location: 'Cengger Ayam',
      price: 'Rp 650.000',
      type: 'Kost',
      status: 'Active',
    ),
<<<<<<< HEAD
    Booking(
      title: 'Laundry Express',
      location: 'Lowokwaru',
      price: 'Rp 35.000',
      type: 'Jasa',
      status: 'Completed',
    ),
=======

>>>>>>> Stashed changes
>>>>>>> ailsa
  ];

  List<Booking> getFilteredBookings(String status) {
    return allBookings.where((booking) => booking.status == status).toList();
  }

  String getEmptyMessage(String status) {
    switch (status) {
      case 'Completed':
        return 'You have no completed booking';
      case 'Canceled':
        return 'You have no canceled booking';
      default:
        return 'You have no active set booking';
    }
  }
}
