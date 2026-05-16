import 'package:flutter/material.dart';

enum AdminHistoryType {
  kosApproved,
  kosRejected,
  jasaApproved,
  jasaRejected,
  laporanCreated,
}

class AdminHistoryDetailModel {
  final String title;
  final String subtitle;
  final String date;
  final AdminHistoryType type;

  // Detail “baris informasi”
  final String pihak;
  final String kategori;
  final String objek;
  final String status;

  // Optional info tambahan
  final String? alasanPenolakan;
  final String? idDokumen;

  // Supaya style detail konsisten dengan card di halaman History
  final IconData icon;
  final Color iconColor;

  const AdminHistoryDetailModel({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.type,
    required this.pihak,
    required this.kategori,
    required this.objek,
    required this.status,
    this.alasanPenolakan,
    this.idDokumen,
    required this.icon,
    required this.iconColor,
  });
}
