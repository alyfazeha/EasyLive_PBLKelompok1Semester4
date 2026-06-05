import 'package:flutter/material.dart';

class OwnerVehicle {
  final String idJasa;
  final String name;
  final String image;
  final String address;
  final String capacity;
  final String availability;
  final String income;
  final String status;
  final Color statusColor;

  const OwnerVehicle({
    required this.idJasa,
    required this.name,
    required this.image,
    required this.address,
    required this.capacity,
    required this.availability,
    required this.income,
    required this.status,
    required this.statusColor,
  });

  bool get isNetworkImage => image.startsWith('http');
}