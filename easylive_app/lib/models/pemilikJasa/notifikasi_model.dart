import 'package:flutter/material.dart';

enum OwnerNotificationType {
  rejected,
  booking,
  payment,
  checkout,
  reminder,
  cancelled,
  approved, // ← tambah
}

class OwnerNotification {
  final String id; // ← tambah
  final String title;
  final String description;
  final String time;
  final OwnerNotificationType type;
  final bool isRead;

  const OwnerNotification({
    required this.id, // ← tambah
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case OwnerNotificationType.rejected:
        return Icons.cancel_outlined;
      case OwnerNotificationType.booking:
        return Icons.receipt_long_outlined;
      case OwnerNotificationType.payment:
        return Icons.credit_card_rounded;
      case OwnerNotificationType.checkout:
        return Icons.done_all_rounded;
      case OwnerNotificationType.reminder:
        return Icons.notifications_rounded;
      case OwnerNotificationType.cancelled:
        return Icons.block_rounded;
      case OwnerNotificationType.approved:
        return Icons.check_circle_outline_rounded; // ← tambah
    }
  }

  Color get color {
    switch (type) {
      case OwnerNotificationType.rejected:
        return const Color(0xFFE4251B);
      case OwnerNotificationType.booking:
        return const Color(0xFF2F80ED);
      case OwnerNotificationType.payment:
        return const Color(0xFF0C7A3D);
      case OwnerNotificationType.checkout:
        return const Color(0xFF7B61FF);
      case OwnerNotificationType.reminder:
        return const Color(0xFFFF7A21);
      case OwnerNotificationType.cancelled:
        return const Color(0xFFE4251B);
      case OwnerNotificationType.approved:
        return const Color(0xFF0C7A3D); // ← tambah
    }
  }
}