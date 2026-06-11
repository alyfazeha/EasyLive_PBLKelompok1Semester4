class Booking {
  final String title;
  final String location;
  final String price;
  final String type;
  final String status;
  final String date;
  final String? rawStatus;
  final String? alasanPenolakan; // ← tambah ini
  final int? idBooking;          // ← tambah ini untuk fetch detail

  Booking({
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.status,
    required this.date,
    this.rawStatus,
    this.alasanPenolakan,
    this.idBooking,
  });
}