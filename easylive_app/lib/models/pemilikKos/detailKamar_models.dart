class Kost {
  final String name;
  final String address;
  final int totalRoom;
  final int availableRoom;
  final String price;
  final String description;
  final List<String> images;
  final List<String> facilities;

  Kost({
    required this.name,
    required this.address,
    required this.totalRoom,
    required this.availableRoom,
    required this.price,
    required this.description,
    required this.images,
    required this.facilities,
  });
}
