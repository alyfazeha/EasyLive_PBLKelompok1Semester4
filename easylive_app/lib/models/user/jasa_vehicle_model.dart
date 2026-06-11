class JasaVehicle {
  final int? id;
  final String name;       // nama_jasa
  final String address;    // alamat
  final String kecamatan;
  final String kota;
  final String image;      // gambar[0]
  final String price;      // price_km (formatted)
  final String description; // deskripsi
  final List<String> specifications; // tipe_mobil, kapasitas
  final String nomorHp;    // nomor_hp
  final String nomorPlat;  // nomor_plat
  final String? ownerId;   // owner_id
  final String status;     // status

  const JasaVehicle({
    this.id,
    required this.name,
    required this.address,
    required this.kecamatan,
    required this.kota,
    required this.image,
    required this.price,
    required this.description,
    required this.specifications,
    required this.nomorHp,
    required this.nomorPlat,
    this.ownerId,
    this.status = 'aktif',
  });
}