import 'package:flutter/material.dart';

import '../../models/admin/history_detail_model.dart';
import '../../models/admin/history_model.dart';

class AdminHistoryDetailController {
  final HistoryItemModel historyItem;

  late final AdminHistoryDetailModel historyDetail;

  AdminHistoryDetailController({
    required HistoryItemModel historyItem,
  }) : historyItem = historyItem {
    historyDetail = _mapFromHistoryItem(historyItem);
  }

  AdminHistoryDetailModel _mapFromHistoryItem(HistoryItemModel item) {
    final lowerTitle = item.title.toLowerCase();

    AdminHistoryType type;
    if (lowerTitle.contains('disetujui') && lowerTitle.contains('kos')) {
      type = AdminHistoryType.kosApproved;
    } else if (lowerTitle.contains('ditolak') && lowerTitle.contains('kos')) {
      type = AdminHistoryType.kosRejected;
    } else if (lowerTitle.contains('disetujui') &&
        (lowerTitle.contains('jasa') || lowerTitle.contains('laundry'))) {
      type = AdminHistoryType.jasaApproved;
    } else if (lowerTitle.contains('ditolak') &&
        (lowerTitle.contains('jasa') || lowerTitle.contains('laundry'))) {
      type = AdminHistoryType.jasaRejected;
    } else {
      type = AdminHistoryType.laporanCreated;
    }

    final status = getStatusLabel(type);
    return AdminHistoryDetailModel(
      title: item.title,
      subtitle: item.subtitle,
      date: item.date,
      type: type,
      pihak: 'Admin',
      kategori: type.toString().split('.').last,
      objek: item.title,
      status: status,
      alasanPenolakan: type == AdminHistoryType.kosRejected ||
              type == AdminHistoryType.jasaRejected
          ? 'Tidak memenuhi persyaratan.'
          : null,
      idDokumen: null,
      icon: getHeaderIcon(type),
      iconColor: getHeaderIconColor(type),
    );
  }

  Color getStatusColor(AdminHistoryType type) {
    switch (type) {
      case AdminHistoryType.kosApproved:
      case AdminHistoryType.jasaApproved:
        return const Color(0xFF0C7A3D);
      case AdminHistoryType.kosRejected:
      case AdminHistoryType.jasaRejected:
        return const Color(0xFFE4251B);
      case AdminHistoryType.laporanCreated:
      default:
        return const Color(0xFF2F80ED);
    }
  }

  String getStatusLabel(AdminHistoryType type) {
    switch (type) {
      case AdminHistoryType.kosApproved:
        return 'Disetujui';
      case AdminHistoryType.kosRejected:
        return 'Ditolak';
      case AdminHistoryType.jasaApproved:
        return 'Disetujui';
      case AdminHistoryType.jasaRejected:
        return 'Ditolak';
      case AdminHistoryType.laporanCreated:
      default:
        return 'Dibuat';
    }
  }

  IconData getHeaderIcon(AdminHistoryType type) {
    switch (type) {
      case AdminHistoryType.kosApproved:
      case AdminHistoryType.jasaApproved:
        return Icons.check_circle_rounded;
      case AdminHistoryType.kosRejected:
      case AdminHistoryType.jasaRejected:
        return Icons.cancel_rounded;
      case AdminHistoryType.laporanCreated:
      default:
        return Icons.bar_chart;
    }
  }

  Color getHeaderBgColor(AdminHistoryType type) {
    switch (type) {
      case AdminHistoryType.kosApproved:
      case AdminHistoryType.jasaApproved:
        return const Color(0xFFE8F8EE);
      case AdminHistoryType.kosRejected:
      case AdminHistoryType.jasaRejected:
        return const Color(0xFFFFEBEB);
      case AdminHistoryType.laporanCreated:
      default:
        return const Color(0xFFEBF3FF);
    }
  }

  Color getHeaderIconColor(AdminHistoryType type) {
    switch (type) {
      case AdminHistoryType.kosApproved:
      case AdminHistoryType.jasaApproved:
        return const Color(0xFF0C7A3D);
      case AdminHistoryType.kosRejected:
      case AdminHistoryType.jasaRejected:
        return const Color(0xFFE4251B);
      case AdminHistoryType.laporanCreated:
      default:
        return const Color(0xFF2F80ED);
    }
  }
}
