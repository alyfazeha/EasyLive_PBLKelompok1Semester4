class Booking {
  final String idBooking;
  String nama;
  String kendaraan;
  String status;
  String? profileImage;
  String? tanggal;
  String? jam;
  final String idProfile;
  final String titikPenjemputan;
  final String titikTujuan;
  final double totalBayar;

  Booking({
    required this.idBooking,
    required this.nama,
    required this.kendaraan,
    required this.status,
    required this.idProfile,
    required this.titikPenjemputan,
    required this.titikTujuan,
    required this.totalBayar,
    this.profileImage,
    this.tanggal,
    this.jam,
  });
}