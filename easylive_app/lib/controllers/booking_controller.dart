import '../models/booking_model.dart';

class BookingController {
  List<Booking> allBookings = [
    Booking(title: "Kost Melati", location: "Cengger Ayam", price: "Rp 650.000", status: "Active"),
  ];

  List<Booking> getFilteredBookings(String status) {
    return allBookings.where((b) => b.status == status).toList();
  }
}
