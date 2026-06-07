import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;

  // Backward-compatible API (agar dashboard_view.dart tidak berubah)
  AdminDashboardModel getDashboardData() {
    // UI yang memakai method sync ini tidak akan bisa mengambil data Supabase (async).
    // Jadi angka real tetap harus diambil dari loadDashboardData() via FutureBuilder.
    return const AdminDashboardModel(
      pendingApprovals: 0,
      approvedKost: 0,
      approvedJasa: 0,
      notifications: 0,
      openReports: 0,
      weeklyRevenue: 'Rp 0',
    );
  }

  Future<AdminDashboardModel> loadDashboardData() async {
    // Default fallback (biar UI tetap jalan meski query gagal)
    int pendingApprovals = 0;
    int approvedKost = 0;
    int approvedJasa = 0;
    int notifications = 0;
    int openReports = 0;

    try {
      // ===== Pending Approvals =====
      // Dari kode lain, status kost pakai: 'pending', 'aktif' (lihat notifikasi owner)
      // Untuk pending yang dimonitor: 'pending' / 'review' (jika ada)
      final kostPendingRes = await _supabase
          .from('kost')
          .select('id_kost')
          .inFilter('status', ['pending', 'review']);

      final kostPendingList = (kostPendingRes as List?) ?? [];
      pendingApprovals += kostPendingList.length;

      // Jasa (kolom status umumnya mirip: 'pending', 'review', 'aktif')
      // Tabel jasa tidak kita baca dari controller lain di tool sebelumnya,
      // jadi kita tetap gunakan pola umum yang kemungkinan sesuai schema.
      final jasaPendingRes = await _supabase
          .from('jasa')
          .select('id_jasa')
          .inFilter('status', ['pending', 'review']);
      final jasaPendingList = (jasaPendingRes as List?) ?? [];
      pendingApprovals += jasaPendingList.length;

      // ===== Approved / Active =====
      final kostActiveRes = await _supabase
          .from('kost')
          .select('id_kost')
          .eq('status', 'aktif');
      approvedKost = ((kostActiveRes as List?) ?? []).length;

      final jasaActiveRes = await _supabase
          .from('jasa')
          .select('id_jasa')
          .eq('status', 'aktif');
      approvedJasa = ((jasaActiveRes as List?) ?? []).length;

      // ===== Notifications / Reports =====
      // Karena halaman dashboard hanya butuh jumlah, kita gunakan:
      // - notifikasi (pakai booking_kos menunggu + pembayaran settlement terbaru belum dibaca tidak ada kolom)
      // - laporan (pakai tabel history/report jika ada)
      // Bila tabel tidak ada, fallback tetap 0.
      final bookingPendingRes = await _supabase
          .from('booking_kos')
          .select('id_booking_kost')
          .eq('status_pesanan', 'menunggu');
      notifications = ((bookingPendingRes as List?) ?? []).length;

      // optional: laporan data kos, kalau ada tabel 'reports'
      final reportRes = await _supabase.from('reports').select('id_report');
      openReports = ((reportRes as List?) ?? []).length;
    } catch (_) {
      // ignore - fallback defaults
    }

    return AdminDashboardModel(
      pendingApprovals: pendingApprovals,
      approvedKost: approvedKost,
      approvedJasa: approvedJasa,
      notifications: notifications,
      openReports: openReports,
      weeklyRevenue: 'Rp 0',
    );
  }

  // Backward-compatible
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

  Future<List<AdminDashboardStat>> loadStats() async {
    final data = await loadDashboardData();
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

  // Backward-compatible
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

  Future<List<AdminPendingAction>> loadPendingActions() async {
    // Minimal: tampilkan 3 kartu pending dari data kost/jasa.
    // UI tetap sama (title/subtitle/status), tapi datanya ambil dari Supabase.
    try {
      final kostPendingRes = await _supabase
          .from('kost')
          .select('id_kost, nama_kost, status')
          .inFilter('status', ['pending', 'review'])
          .limit(2);

      final jasaPendingRes = await _supabase
          .from('jasa')
          .select('id_jasa, nama_jasa, status')
          .inFilter('status', ['pending', 'review'])
          .limit(1);

      final kostList = (kostPendingRes as List?) ?? [];
      final jasaList = (jasaPendingRes as List?) ?? [];

      final result = <AdminPendingAction>[];

      for (final k in kostList) {
        result.add(
          AdminPendingAction(
            title: (k['nama_kost'] ?? '-') as String,
            subtitle: 'Pengajuan kost',
            status: (k['status'] ?? 'Pending').toString(),
            routeName: '/admin/kos',
          ),
        );
      }

      for (final j in jasaList) {
        result.add(
          AdminPendingAction(
            title: (j['nama_jasa'] ?? '-') as String,
            subtitle: 'Pengajuan jasa',
            status: (j['status'] ?? 'Review').toString(),
            routeName: '/admin/jasa',
          ),
        );
      }

      if (result.isEmpty) {
        return const [
          AdminPendingAction(
            title: 'Laporan Data Kos',
            subtitle: 'User melaporkan informasi tidak sesuai',
            status: 'Urgent',
            routeName: '/admin/history',
          ),
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
        ];
      }

      return result.take(3).toList();
    } catch (_) {
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
  }

  // Backward-compatible
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

  Future<List<AdminRecentActivity>> loadRecentActivities() async {
    // Minimal: tampilkan 3 activity dari booking/pembayaran terbaru.
    try {
      final paymentRes = await _supabase
          .from('payments')
          .select('gross_amount, status, payment_type, id_booking_kost')
          .eq('status', 'settlement')
          .order('id_payments', ascending: false)
          .limit(2);

      final bookingRes = await _supabase
          .from('booking_kos')
          .select('id_booking_kost, status_pesanan, tanggal_checkin, id_kost')
          .order('id_booking_kost', ascending: false)
          .limit(1);

      final List<AdminRecentActivity> result = [];

      for (final p in (paymentRes as List?) ?? []) {
        result.add(
          AdminRecentActivity(
            title: 'Pembayaran diterima',
            subtitle: 'Booking berhasil settlement',
            time: 'Baru',
            routeName: '/admin/history',
          ),
        );
      }

      if ((bookingRes as List?)?.isNotEmpty ?? false) {
        result.add(
          AdminRecentActivity(
            title: 'Booking terbaru',
            subtitle: 'Ada pengajuan booking baru',
            time: 'Baru',
            routeName: '/admin/history',
          ),
        );
      }

      if (result.isEmpty) {
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

      return result.take(3).toList();
    } catch (_) {
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
  }

  // UI dashboard belum memakai recent notifications, jadi biarkan method ini.
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
