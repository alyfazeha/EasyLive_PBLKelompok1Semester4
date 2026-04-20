class KostModel {
  final String name;
  final String address;
  final String image;
  final int? price;   
  final String? loc;  

  KostModel({
    required this.name,
    required this.address,
    required this.image,
    this.price,
    this.loc,
  });
}