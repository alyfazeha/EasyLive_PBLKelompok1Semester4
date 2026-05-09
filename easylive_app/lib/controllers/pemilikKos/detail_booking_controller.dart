import 'package:flutter/material.dart';

import '../../models/pemilikKos/detail_booking_model.dart';

class DetailBookingController extends ChangeNotifier {
  final String tenantName;

  DetailBookingController({required this.tenantName});

  DetailBookingModel get booking {
    return _bookings[tenantName] ?? _bookings.values.first;
  }

  static const Map<String, DetailBookingModel> _bookings = {
    'Budi Santoso': DetailBookingModel(
      tenantName: 'Budi Santoso',
      phone: '0838 7198 3300',
      email: 'hamdirat130@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '03',
      checkInDate: '01 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Aktif',
    ),
    'Andi Wijaya': DetailBookingModel(
      tenantName: 'Andi Wijaya',
      phone: '0812 4455 1199',
      email: 'andiwijaya@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '01',
      checkInDate: '03 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Aktif',
    ),
    'Siti Aminah': DetailBookingModel(
      tenantName: 'Siti Aminah',
      phone: '0821 7788 2211',
      email: 'sitiaminah@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '02',
      checkInDate: '05 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Aktif',
    ),
    'Rudi Hartono': DetailBookingModel(
      tenantName: 'Rudi Hartono',
      phone: '0857 6400 1122',
      email: 'rudihartono@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '04',
      checkInDate: '08 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Aktif',
    ),
    'Dwi Lestari': DetailBookingModel(
      tenantName: 'Dwi Lestari',
      phone: '0813 2233 8899',
      email: 'dwilestari@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '05',
      checkInDate: '10 Mei 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Aktif',
    ),
    'Ahmad Fauzi': DetailBookingModel(
      tenantName: 'Ahmad Fauzi',
      phone: '0896 3344 5511',
      email: 'ahmadfauzi@gmail.com',
      kosName: 'Daniska Kost',
      roomName: '06',
      checkInDate: '14 April 2026',
      monthlyPrice: 'Rp 1.500.000',
      paymentStatus: 'Paid',
      bookingStatus: 'Done',
    ),
  };
}
