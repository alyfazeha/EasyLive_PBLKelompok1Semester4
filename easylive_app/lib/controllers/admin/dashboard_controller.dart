import 'package:flutter/material.dart';

import '../../models/admin/dashboard_model.dart';

class NotificationItemModel {
  final String title;
  final IconData icon;
  final Color color;

  NotificationItemModel({
    required this.title,
    required this.icon,
    required this.color,
  });
}

// ── Controller ───────────────────────────────────────
class AdminHomeController {
  AdminDashboardModel getDashboardData() {
    return const AdminDashboardModel(
      pendingApprovals: 24,
      approvedKost: 128,
      approvedJasa: 59,
      notifications: 8,
      openReports: 6,
      weeklyRevenue: 'Rp 12,4 jt',
    );
  }

  List<AdminDashboardStat> getStats() {
    final data = getDashboardData();
    return [
      AdminDashboardStat(
        title: 'Pending Approval',
        value: data.pendingApprovals.toString(),
        caption: 'Kost & jasa perlu dicek',
        routeName: '/admin/kos',
      ),
      AdminDashboardStat(
        title: 'Kost Aktif',
        value: data.approvedKost.toString(),
        caption: 'Unit terverifikasi',
        routeName: '/admin/kos',
      ),
      AdminDashboardStat(
        title: 'Jasa Aktif',
        value: data.approvedJasa.toString(),
        caption: 'Layanan tersedia',
        routeName: '/admin/jasa',
      ),
      AdminDashboardStat(
        title: 'Notifikasi',
        value: data.notifications.toString(),
        caption: 'Update terbaru',
        routeName: '/admin/notifikasi',
      ),
    ];
  }

  List<AdminQuickAction> getQuickActions() {
    return const [
      AdminQuickAction(
        title: 'Review Kost',
        subtitle: 'Cek pengajuan terbaru',
        routeName: '/admin/kos',
      ),
      AdminQuickAction(
        title: 'Kelola Jasa',
        subtitle: 'Pantau layanan aktif',
        routeName: '/admin/jasa',
      ),
      AdminQuickAction(
        title: 'History',
        subtitle: 'Lihat aktivitas sistem',
        routeName: '/admin/history',
      ),
    ];
  }

  List<AdminPendingAction> getPendingActions() {
    return const [
      AdminPendingAction(
        title: 'Comfort Living Kost',
        subtitle: 'Pengajuan kost dari Budi Santoso',
        status: 'Pending',
        routeName: '/admin/kos',
      ),
      AdminPendingAction(
        title: 'EasyMove Reguler',
        subtitle: 'Penyedia jasa pindahan baru',
        status: 'Review',
        routeName: '/admin/jasa',
      ),
      AdminPendingAction(
        title: 'Laporan Data Kos',
        subtitle: 'User melaporkan informasi tidak sesuai',
        status: 'Urgent',
        routeName: '/admin/history',
      ),
    ];
  }

  List<AdminRecentActivity> getRecentActivities() {
    return const [
      AdminRecentActivity(
        title: 'Pembayaran diterima',
        subtitle: 'Booking kost berhasil settlement',
        time: '1 jam lalu',
        routeName: '/admin/history',
      ),
      AdminRecentActivity(
        title: 'Kost disetujui',
        subtitle: 'Daniska Kost sudah aktif',
        time: 'Kemarin',
        routeName: '/admin/kos',
      ),
      AdminRecentActivity(
        title: 'Notifikasi sistem',
        subtitle: 'Ada 8 update yang belum dibaca',
        time: '2 hari lalu',
        routeName: '/admin/notifikasi',
      ),
    ];
  }

  List<NotificationItemModel> getRecentNotifications() {
    return [
      NotificationItemModel(
        title: 'Laundry service updated',
        icon: Icons.local_laundry_service,
        color: Colors.amber,
      ),
      NotificationItemModel(
        title: 'New kost owner request',
        icon: Icons.home_work,
        color: Colors.green,
      ),
    ];
  }
}
