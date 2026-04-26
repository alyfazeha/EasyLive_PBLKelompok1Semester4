import '../models/booking_model.dart';

class BookingController {
<<<<<<< Updated upstream
  List<Booking> allBookings = [
    Booking(title: "Kost Melati", location: "Cengger Ayam", price: "Rp 650.000", status: "Active"),
=======
  static const List<String> bookingStatuses = ['Active', 'Completed', 'Canceled'];

  final List<Booking> allBookings = [
    Booking(
      title: 'Kost Melati',
      location: 'Cengger Ayam',
      price: 'Rp 650.000',
      type: 'Kost',
      status: 'Active',
    ),

>>>>>>> Stashed changes
  ];

  List<Booking> getFilteredBookings(String status) {
    return allBookings.where((b) => b.status == status).toList();
  }
}
