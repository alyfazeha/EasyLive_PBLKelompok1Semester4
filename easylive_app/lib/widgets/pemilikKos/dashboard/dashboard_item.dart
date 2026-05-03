import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../models/pemilikKos/dashboard_model.dart';

class DashboardItem extends StatelessWidget {
  final Dashboard data;

  const DashboardItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// ICON BULAT BERWARNA
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: getColor(data.type).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(data.type),
              color: getColor(data.type),
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          /// TIME
          Text(
            data.time,
            style: const TextStyle(color: AppColors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// ICON BERDASARKAN TYPE
  IconData getIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.receipt_long;
      case 'payment':
        return Icons.payments;
      case 'checkout':
        return Icons.logout;
      default:
        return Icons.notifications;
    }
  }

  ///  WARNA BERDASARKAN TYPE
  Color getColor(String type) {
    switch (type) {
      case 'booking':
        return AppColors.amber;
      case 'payment':
        return AppColors.golden;
      case 'checkout':
        return AppColors.primary;
      default:
        return AppColors.grey;
    }
  }
}
