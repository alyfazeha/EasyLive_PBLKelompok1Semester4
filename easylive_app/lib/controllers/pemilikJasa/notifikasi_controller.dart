import 'package:flutter/material.dart';

import '../../models/pemilikJasa/notifikasi_model.dart';

class OwnerJasaNotificationController extends ChangeNotifier {
  bool showUnreadOnly = false;

  final List<OwnerNotification> _notifications = const [
    OwnerNotification(
      title: 'Booking baru',
      description: 'Ada booking baru untuk jasa\nPaket Pickup',
      time: 'baru saja',
      type: OwnerNotificationType.booking,
    ),
    OwnerNotification(
      title: 'Kamar sudah checkout',
      description: 'Transaksi checkout berhasil\nuntuk Paket Pickup',
      time: '5 menit lalu',
      type: OwnerNotificationType.checkout,
    ),
    OwnerNotification(
      title: 'Pembayaran diterima',
      description: 'Pembayaran diterima\nsebesar Rp 150.000',
      time: '2 jam lalu',
      type: OwnerNotificationType.payment,
    ),
    OwnerNotification(
      title: 'Pengingat pembayaran',
      description: 'Anda belum melakukan pembayaran\npada bulan ini',
      time: '2 hari lalu',
      type: OwnerNotificationType.reminder,
    ),
    OwnerNotification(
      title: 'Booking dibatalkan',
      description: 'Booking dibatalkan\noleh penyewa',
      time: '3 hari lalu',
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

  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  void showAll() {
    showUnreadOnly = false;
    notifyListeners();
  }

  void showUnread() {
    showUnreadOnly = true;
    notifyListeners();
  }
}


