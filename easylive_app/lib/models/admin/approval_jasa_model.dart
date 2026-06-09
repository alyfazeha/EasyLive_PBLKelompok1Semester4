class ApprovalJasaModel {
  final String idJasa;
  final String namaJasa;
  final String? tipeMobil;
  final double priceMobil;
  final double priceKm;
  final List<String> gambar;
  final String status;
  final String? alamat;
  final String? kecamatan;
  final String? kota;
  final String? nomorHp;
  final String? nomorPlat;
  final String? kapasitas;
  final String? deskripsi;
  final String? rejectionReason;
  final String ownerName;
  final String ownerEmail;
  final String ownerProfileImage;

  ApprovalJasaModel({
    required this.idJasa,
    required this.namaJasa,
    this.tipeMobil,
    required this.priceMobil,
    required this.priceKm,
    required this.gambar,
    required this.status,
    this.alamat,
    this.kecamatan,
    this.kota,
    this.nomorHp,
    this.nomorPlat,
    this.kapasitas,
    this.deskripsi,
    this.rejectionReason,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerProfileImage,
  });

  String get fullAddress {
    final parts = [alamat, kecamatan, kota]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.join(', ') : '-';
  }

  factory ApprovalJasaModel.fromMap(Map<String, dynamic> map) {
    final owner = map['owner'] as Map<String, dynamic>?;

    const String defaultAvatar =
        'https://ui-avatars.com/api/?name=Owner&background=243B55&color=ffffff';

    final List<String> photos =
        (map['gambar'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList();

    // ← fix: hapus ? di return
    final String profilePhotoUrl =
        owner?['photo']?.toString().trim() ?? '';

    return ApprovalJasaModel(
      idJasa: map['id_jasa'].toString(),
      namaJasa: map['nama_jasa']?.toString() ?? '-',
      tipeMobil: map['tipe_mobil']?.toString(),
      priceMobil: (map['price_mobil'] as num?)?.toDouble() ?? 0,
      priceKm: (map['price_km'] as num?)?.toDouble() ?? 0,
      gambar: photos,
      status: map['status']?.toString() ?? 'pending',
      alamat: map['alamat']?.toString(),
      kecamatan: map['kecamatan']?.toString(),
      kota: map['kota']?.toString(),
      nomorHp: map['nomor_hp']?.toString(),
      nomorPlat: map['nomor_plat']?.toString(),
      kapasitas: map['kapasitas']?.toString(),
      deskripsi: map['deskripsi']?.toString(),
      rejectionReason: map['alasan_tolak']?.toString(),
      ownerName: owner?['full_name']?.toString() ?? 'Unknown Owner',
      ownerEmail: owner?['email']?.toString() ?? '-',
      ownerProfileImage: profilePhotoUrl.isNotEmpty // ← fix
          ? profilePhotoUrl
          : defaultAvatar,
    );
  }
}