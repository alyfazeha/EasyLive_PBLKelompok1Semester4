import 'package:flutter/material.dart';

class JasaPindahModel {
  final String fromLocation;
  final String toLocation;
  final String monthYear;
  final List<Map<String, String>> availableDates;

  JasaPindahModel({
    required this.fromLocation,
    required this.toLocation,
    required this.monthYear,
    required this.availableDates,
  });
}

class VehicleOption {
  final String name;
  final String capacity;
  final IconData icon;

  VehicleOption({
    required this.name, 
    required this.capacity, 
    required this.icon,
  });
}