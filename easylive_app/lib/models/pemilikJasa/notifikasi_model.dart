import 'package:flutter/material.dart';

enum OwnerNotificationType {
  rejected,
  booking,
  payment,
  checkout,
  reminder,
  cancelled,
}

class OwnerNotification {
  final String title;
  final String description;
  final String time;
  final OwnerNotificationType type;
  final bool isRead;

  const OwnerNotification({
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
    }
  }

  /// Warna notifikasi sesuai permintaan: merah sampai hijau.
  /// - booking baru: biru
  /// - checkout: ungu
  /// - pembayaran diterima: hijau
  /// - pengingat pembayaran: oranye
  /// - booking dibatalkan: merah
  Color get color {
    switch (type) {
      case OwnerNotificationType.rejected:
        return const Color(0xFFE4251B); // merah
      case OwnerNotificationType.booking:
        return const Color(0xFF2F80ED); // biru
      case OwnerNotificationType.payment:
        return const Color(0xFF0C7A3D); // hijau
      case OwnerNotificationType.checkout:
        return const Color(0xFF7B61FF); // ungu
      case OwnerNotificationType.reminder:
        return const Color(0xFFFF7A21); // oranye
      case OwnerNotificationType.cancelled:
        return const Color(0xFFE4251B); // merah
    }
  }
}

