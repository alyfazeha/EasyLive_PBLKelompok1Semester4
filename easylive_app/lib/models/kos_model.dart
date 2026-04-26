class KostModel {
  final String name;
  final String address;
  final String image;
  final int? price;   
  final String? loc;  

  // Field tambahan untuk Detail
  final String? description;
  final List<String>? specifications;
  final List<String>? facilities;
  final int? availableRooms;
  final String? detailImage; // Optional, bisa digunakan untuk identifikasi unik jika diperlukan

  KostModel({
    required this.name,
    required this.address,
    required this.image, 
    this.price,
    this.loc,
    this.description,
    this.specifications,
    this.facilities,
    this.availableRooms,
    this.detailImage,
  });
}