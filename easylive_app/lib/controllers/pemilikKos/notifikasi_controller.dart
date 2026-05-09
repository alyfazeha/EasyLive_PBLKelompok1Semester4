import 'package:flutter/material.dart';

import '../../models/pemilikKos/notifikasi_model.dart';

class OwnerNotificationController extends ChangeNotifier {
  bool showUnreadOnly = false;

  final List<OwnerNotification> _notifications = const [
    OwnerNotification(
      title: 'Application rejected by admin',
      description: 'Pengajuan Daniska Kos ditolak\noleh admin aplikasi',
      time: 'now',
      type: OwnerNotificationType.rejected,
    ),
    OwnerNotification(
      title: 'New Booking',
      description: 'Ada booking baru di Daniska Kos\nKamar 03',
      time: '5 minutes ago',
      type: OwnerNotificationType.booking,
    ),
    OwnerNotification(
      title: 'Payment accepted',
      description: 'Pembayaran dari Budi Santoso\nsebesar Rp 150.000',
      time: '2 hours ago',
      type: OwnerNotificationType.payment,
    ),
    OwnerNotification(
      title: 'The room has been checked out',
      description: 'Kamar 05 - di Triple A Kos sudah\ncheckout',
      time: 'yesterday',
      type: OwnerNotificationType.checkout,
    ),
    OwnerNotification(
      title: 'Payment reminder',
      description: 'Andi Wijaya belum melakukan\npembayaran bulan ini',
      time: '2 hari lalu',
      type: OwnerNotificationType.reminder,
      isRead: true,
    ),
    OwnerNotification(
      title: 'Booking cancelled',
      description: 'Booking Kamar 03 dibatalkan\noleh penyewa',
      time: '3 days ago',
      type: OwnerNotificationType.cancelled,
      isRead: true,
    ),
  ];

  List<OwnerNotification> get notifications {
    if (showUnreadOnly) {
      return _notifications.where((item) => !item.isRead).toList();
    }

    return _notifications;
  }

  int get totalCount => _notifications.length;

  int get unreadCount =>
      _notifications.where((item) => !item.isRead).length;

  void showAll() {
    showUnreadOnly = false;
    notifyListeners();
  }

  void showUnread() {
    showUnreadOnly = true;
    notifyListeners();
  }
}
