import 'package:flutter/material.dart';

import '../../../models/pemilikJasa/detail_booking_model.dart';

class DetailBookingJasaController extends ChangeNotifier {
  final String tenantName;

  DetailBookingJasaController({required this.tenantName});

  DetailBookingModel get booking {
    return _bookings[tenantName] ?? _bookings.values.first;
  }

  static final Map<String, DetailBookingModel> _bookings = {
    'Budi Santoso': DetailBookingModel(
      tenantName: 'Budi Santoso',
      phone: '0838 7198 3300',
      email: 'hamdirafi310@gmail.com',
      jasaName: 'Jasa Pickup - BOX',
      kendaraanName: 'Pickup - BOX',
      checkInDate: '01 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Lunas',
      bookingStatus: 'Aktif',
    ),
    'Andi Wijaya': DetailBookingModel(
      tenantName: 'Andi Wijaya',
      phone: '0812 4455 1199',
      email: 'andiwijaya@gmail.com',
      jasaName: 'Jasa Pickup - BOX',
      kendaraanName: 'Pickup - BOX',
      checkInDate: '03 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Lunas',
      bookingStatus: 'Aktif',
    ),
    'Siti Aminah': DetailBookingModel(
      tenantName: 'Siti Aminah',
      phone: '0821 7788 2211',
      email: 'sitiaminah@gmail.com',
      jasaName: 'Jasa Pickup - BOX',
      kendaraanName: 'Pickup - BOX',
      checkInDate: '05 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Lunas',
      bookingStatus: 'Aktif',
    ),
    'Rudi Hartono': DetailBookingModel(
      tenantName: 'Rudi Hartono',
      phone: '0857 6400 1122',
      email: 'rudihartono@gmail.com',
      jasaName: 'Jasa Pickup - BOX',
      kendaraanName: 'Pickup - BOX',
      checkInDate: '08 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Lunas',
      bookingStatus: 'Selesai',
    ),
  };
}

