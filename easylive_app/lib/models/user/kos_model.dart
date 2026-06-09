class KostModel {
  final String name;
  final String address;
  final String image;
  final int? price;

  // Field tambahan untuk Detail
  final String? loc;
  final String? kecamatan;
  final String? kota;
  final int? availableRooms;
  final int? emptyRooms;
  final String? kostType; // putra/putri/campur

  final String? description;
  final List<String>? specifications;
  final List<String>? facilities;
  final String?
  detailImage; // Optional, bisa digunakan untuk identifikasi unik jika diperlukan

  KostModel({
    required this.name,
    required this.address,
    required this.image,
    this.price,
    this.loc,
    this.kecamatan,
    this.kota,
    this.availableRooms,
    this.emptyRooms,
    this.kostType,
    this.description,
    this.specifications,
    this.facilities,
    this.detailImage,
  });
}