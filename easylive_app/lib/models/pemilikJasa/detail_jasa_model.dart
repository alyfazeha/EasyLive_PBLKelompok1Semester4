class DetailJasa {
  final String name;
  final String address;
  final int totalVehicle;
  final int availableVehicle;
  final String price;
  final String description;
  final List<String> images;
  final List<String> specifications;

  DetailJasa({
    required this.name,
    required this.address,
    required this.totalVehicle,
    required this.availableVehicle,
    required this.price,
    required this.description,
    required this.images,
    required this.specifications,
  });
}
