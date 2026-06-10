import 'package:flutter/material.dart';

class HistoryItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color iconColor;
  final String type; // 'kos' atau 'jasa'
  final String status; // 'aktif' atau 'ditolak'

  HistoryItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.status,
  });
}