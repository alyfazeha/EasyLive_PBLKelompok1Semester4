class Booking {
  String nama;
  String kendaraan;
  String status;
  String? profileImage;
  String? tanggal;
  String? jam;

  Booking({
    required this.nama,
    required this.kendaraan,
    required this.status,
    this.profileImage,
    this.tanggal,
    this.jam,
  });
}

