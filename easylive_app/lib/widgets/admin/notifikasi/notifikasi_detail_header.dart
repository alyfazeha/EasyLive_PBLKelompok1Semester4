import 'package:flutter/material.dart';

import '../../../models/admin/notifikasi/notifikasi_model.dart';

class AdminNotificationDetailHeader extends StatelessWidget {
  final AdminNotificationDetail detail;

  const AdminNotificationDetailHeader({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final notification = detail.notification;
    final color = notification.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(notification.icon, color: color, size: 25),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF243447),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  notification.description,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    height: 1.35,
                    color: Color(0xFF5F6C78),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(label: detail.statusLabel, color: color),
                    _Pill(label: notification.time, color: Colors.grey),
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

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color == Colors.grey ? Colors.black45 : color,
        ),
      ),
    );
  }
}
