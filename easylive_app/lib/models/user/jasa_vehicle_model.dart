import 'package:flutter/foundation.dart';

@immutable
class JasaVehicle {
  final int? id;
  final String name;
  final String address;
  final String kecamatan;
  final String kota;
  final String image;
  final String price;
  final String description;
  final List<String> specifications;
  final int availableUnits;

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
    required this.availableUnits,
  });
}
