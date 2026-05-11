import 'package:flutter/material.dart';

class HistoryItemModel {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color iconColor;

  HistoryItemModel({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}