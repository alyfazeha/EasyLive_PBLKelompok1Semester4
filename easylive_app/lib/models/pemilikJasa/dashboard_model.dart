import 'package:flutter/material.dart';

class JasaDashboardStat {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const JasaDashboardStat({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}

class JasaPaymentHistory {
  final String name;
  final String vehicleType;
  final String location;
  final String date;
  final String price;
  final String status;

  const JasaPaymentHistory({
    required this.name,
    required this.vehicleType,
    required this.location,
    required this.date,
    required this.price,
    required this.status,
  });
}
