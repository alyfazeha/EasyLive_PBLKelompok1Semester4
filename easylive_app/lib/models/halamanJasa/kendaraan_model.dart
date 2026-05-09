class KendaraanModel {
  String namaKendaraan;
  String nomorHp;
  String tipeKendaraan;
  String alamat;
  String kecamatan;
  String kota;
  String nomorPlat;
  String kapasitas;
  String harga;
  String deskripsi;

  KendaraanModel({
    required this.namaKendaraan,
    required this.nomorHp,
    required this.tipeKendaraan,
    required this.alamat,
    required this.kecamatan,
    required this.kota,
    required this.nomorPlat,
    required this.kapasitas,
    required this.harga,
    required this.deskripsi,
  });

  // Convert to Map for saving to database or API
  Map<String, dynamic> toMap() {
    return {
      'namaKendaraan': namaKendaraan,
      'nomorHp': nomorHp,
      'tipeKendaraan': tipeKendaraan,
      'alamat': alamat,
      'kecamatan': kecamatan,
      'kota': kota,
      'nomorPlat': nomorPlat,
      'kapasitas': kapasitas,
      'harga': harga,
      'deskripsi': deskripsi,
    };
  }

  // Create from Map
  factory KendaraanModel.fromMap(Map<String, dynamic> map) {
    return KendaraanModel(
      namaKendaraan: map['namaKendaraan'] ?? '',
      nomorHp: map['nomorHp'] ?? '',
      tipeKendaraan: map['tipeKendaraan'] ?? '',
      alamat: map['alamat'] ?? '',
      kecamatan: map['kecamatan'] ?? '',
      kota: map['kota'] ?? '',
      nomorPlat: map['nomorPlat'] ?? '',
      kapasitas: map['kapasitas'] ?? '',
      harga: map['harga'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
    );
  }
}