class Booking {
  final String idBooking;
  final String nama;
  final String kamar;
  String status;
  final String idProfile;
  final String tanggalCheckin;

  Booking({
    required this.idBooking,
    required this.nama,
    required this.kamar,
    required this.status,
    required this.idProfile,
    required this.tanggalCheckin,
  });
}