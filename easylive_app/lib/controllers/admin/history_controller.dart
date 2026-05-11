import 'package:flutter/material.dart';
import '../../../models/admin/history_model.dart';

class AdminHistoryController {
  List<HistoryItemModel> getHistoryItems() {
    return [
      HistoryItemModel(
        title: 'Kos "Kos Daniska" disetujui',
        subtitle: 'Oleh Admin',
        date: '10 Mei 2024, 10:30',
        icon: Icons.home,
        iconColor: Colors.green,
      ),
      HistoryItemModel(
        title: 'Permohonan jasa disetujui',
        subtitle: 'Oleh Admin',
        date: '10 Mei 2024, 09:15',
        icon: Icons.local_laundry_service,
        iconColor: Colors.blue,
      ),
      HistoryItemModel(
        title: 'Kos "Kos Sejahtera" ditolak',
        subtitle: 'Oleh Admin',
        date: '9 Mei 2024, 16:45',
        icon: Icons.close,
        iconColor: Colors.red,
      ),
      HistoryItemModel(
        title: 'Laporan bulanan Mei 2024 dibuat',
        subtitle: 'Oleh Admin',
        date: '8 Mei 2024, 09:00',
        icon: Icons.bar_chart,
        iconColor: Colors.purple,
      ),
    ];
  }

  List<String> getTabs() {
    return ['Semua', 'Kos', 'Jasa', 'Laporan'];
  }
}