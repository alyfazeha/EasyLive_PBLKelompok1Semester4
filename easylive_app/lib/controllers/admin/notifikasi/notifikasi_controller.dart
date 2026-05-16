import 'package:flutter/material.dart';

import '../../../models/admin/notifikasi/notifikasi_model.dart';

class AdminNotificationController extends ChangeNotifier {
  bool showUnreadOnly = false;
  bool isLoading = false;

  final List<AdminNotification> _notifications = [];

  AdminNotificationController() {
    loadData();
  }

  List<AdminNotification> get notifications {
    if (showUnreadOnly) {
      return _notifications.where((item) => !item.isRead).toList();
    }
    return List.unmodifiable(_notifications);
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

  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || _notifications[index].isRead) return;

    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 250));

    _notifications
      ..clear()
      ..addAll(const [
        AdminNotification(
          id: 'kost_pending_1',
          title: 'Pengajuan Kost Baru',
          description: 'Comfort Living Kost menunggu verifikasi admin.',
          time: 'Baru saja',
          type: AdminNotificationType.kostApproval,
          targetName: 'Comfort Living Kost',
          actionLabel: 'Cek approval kost',
        ),
        AdminNotification(
          id: 'jasa_pending_1',
          title: 'Pengajuan Jasa Baru',
          description: 'EasyMove Reguler mengirim data layanan baru.',
          time: '12 menit lalu',
          type: AdminNotificationType.jasaApproval,
          targetName: 'EasyMove Reguler',
          actionLabel: 'Cek jasa',
        ),
        AdminNotification(
          id: 'payment_settlement_1',
          title: 'Pembayaran Masuk',
          description: 'Pembayaran booking kost berhasil diterima sistem.',
          time: '1 jam lalu',
          type: AdminNotificationType.payment,
          targetName: 'Booking Kost',
          actionLabel: 'Lihat history',
        ),
        AdminNotification(
          id: 'report_user_1',
          title: 'Laporan Pengguna',
          description: 'Ada laporan baru terkait data kos yang perlu ditinjau.',
          time: 'Kemarin',
          type: AdminNotificationType.report,
          isRead: true,
          targetName: 'Laporan Data Kos',
          actionLabel: 'Lihat laporan',
        ),
        AdminNotification(
          id: 'system_review_1',
          title: 'Ringkasan Sistem',
          description: '8 notifikasi aktif dan 24 approval menunggu tindakan.',
          time: '2 hari lalu',
          type: AdminNotificationType.system,
          isRead: true,
          actionLabel: 'Lihat dashboard',
        ),
      ]);

    isLoading = false;
    notifyListeners();
  }
}
