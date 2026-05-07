import 'package:flutter/material.dart';

import '../../models/pemilikJasa/vehicle_model.dart';

class PemilikJasaHomeController {
  final int totalVehicles = 15;
  final int availableVehicles = 6;
  final String totalIncome = 'Rp 5.000.000';
  final int newBookings = 9;
  final String availableRatio = '6 / 15';

  final List<OwnerVehicle> vehicles = const [
    OwnerVehicle(
      name: 'Pickup',
      image: 'assets/images/pickup-removed.png',
      address: 'Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang',
      capacity: '10 pickup',
      availability: '1 available',
      income: 'Rp 8.000 / km',
      status: 'Aktif',
      statusColor: Color(0xFF31B75D),
    ),
    OwnerVehicle(
      name: 'Truck',
      image: 'assets/images/mobilBox-BackgroundRemover.jpg',
      address: 'Jalan Cengger Ayam Dalam III, No 24 Lowokwaru Malang',
      capacity: '5 truck',
      availability: '5 available',
      income: 'Rp 10.000 / km',
      status: 'Penuh',
      statusColor: Color(0xFFE53935),
    ),
  ];
}
