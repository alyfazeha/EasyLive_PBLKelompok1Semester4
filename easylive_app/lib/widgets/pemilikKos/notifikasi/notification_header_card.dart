import 'package:flutter/material.dart';
import '../../../models/pemilikKos/notifikasi_detail_model.dart';
import '../../../models/pemilikKos/notifikasi_model.dart';

class NotificationHeaderCard extends StatelessWidget {
  final NotificationModel data;
  final OwnerNotificationType type;

  const NotificationHeaderCard({
    super.key,
    required this.data,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    // Icon dan warna berdasar type
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case OwnerNotificationType.approved:
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF0C7A3D);
        bgColor = const Color(0xFFE8F8EE);
        break;
      case OwnerNotificationType.rejected:
        icon = Icons.cancel_rounded;
        iconColor = const Color(0xFFE4251B);
        bgColor = const Color(0xFFFFEBEB);
        break;
      case OwnerNotificationType.booking:
        icon = Icons.receipt_long_rounded;
        iconColor = const Color(0xFF2F80ED);
        bgColor = const Color(0xFFEBF3FF);
        break;
      case OwnerNotificationType.payment:
        icon = Icons.credit_card_rounded;
        iconColor = const Color(0xFF0C7A3D);
        bgColor = const Color(0xFFE8F8EE);
        break;
      default:
        icon = Icons.notifications_rounded;
        iconColor = const Color(0xFFFF7A21);
        bgColor = const Color(0xFFFFF3EB);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2F4157),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Baru',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: iconColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      data.time,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}