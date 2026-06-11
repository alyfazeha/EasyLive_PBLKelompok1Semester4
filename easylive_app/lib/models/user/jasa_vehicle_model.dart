import 'package:flutter/foundation.dart';

@immutable
class JasaVehicle {
  final int? id;
  final String name;
  final String address;
  final String image;
  final String price;
  final String description;
  final List<String> specifications;
  final int availableUnits;

  const JasaVehicle({
    this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.price,
    required this.description,
    required this.specifications,
    required this.availableUnits,
  });
}
