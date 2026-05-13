class Booking {
  final String idBooking;
  String nama;
  String kamar;
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