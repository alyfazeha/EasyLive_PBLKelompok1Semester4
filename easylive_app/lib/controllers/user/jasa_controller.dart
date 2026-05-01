import '../../models/user/jasa_model.dart';
import 'package:flutter/material.dart';

class JasaController {
  final List<Map<String, String>> dates = [
    {'day': 'Mon', 'date': '21', 'status': 'inactive'},
    {'day': 'Tue', 'date': '22', 'status': 'active'},
    {'day': 'Wed', 'date': '23', 'status': 'inactive'},
    {'day': 'Thu', 'date': '24', 'status': 'inactive'},
  ];

  final List<VehicleOption> vehicles = [
    VehicleOption(name: 'Pick Up', capacity: 'Max 1.000 kg', icon: Icons.local_shipping),
    VehicleOption(name: 'Blind Van', capacity: 'Max 600 kg', icon: Icons.directions_car),
  ];
}
