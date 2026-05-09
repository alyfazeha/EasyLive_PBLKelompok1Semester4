import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/pemilikJasa/dashboard_model.dart';

class PemilikJasaDashboardController {
  final String ownerName = 'Rafi';
  final int notificationCount = 9;

  final List<JasaDashboardStat> stats = const [
    JasaDashboardStat(
      icon: Icons.local_shipping_outlined,
      title: 'Total Vehicle',
      value: '15 Kendaraan',
      color: AppColors.yellow,
    ),
    JasaDashboardStat(
      icon: Icons.check_circle_outline_rounded,
      title: 'Vehicle Available',
      value: '6 Kendaraan',
      color: AppColors.yellow,
    ),
    JasaDashboardStat(
      icon: Icons.calendar_month_outlined,
      title: 'New Bookings',
      value: '9 Kendaraan',
      color: Color(0xFF4D82FF),
    ),
    JasaDashboardStat(
      icon: Icons.paid_outlined,
      title: 'Total Revenue',
      value: 'Rp 5.000.000',
      color: AppColors.yellow,
    ),
  ];

  final List<JasaPaymentHistory> payments = const [
    JasaPaymentHistory(
      name: 'M. Miftahul Akmal',
      vehicleType: 'Pickup',
      location: 'Daniska KOS',
      date: '01 Mei 2026',
      price: 'Rp 5.500.000',
      status: 'Lunas',
    ),
    JasaPaymentHistory(
      name: 'Ahmad Rafi Hamdi',
      vehicleType: 'Truck',
      location: 'Daniska KOS',
      date: '28 Ags 2026',
      price: 'Rp 5.500.000',
      status: 'Lunas',
    ),
  ];
}
