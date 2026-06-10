import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/admin/notifikasi/notifikasi_model.dart';

class AdminNotificationController extends ChangeNotifier {
  bool isLoading = false;

  final List<AdminNotification> _notifications = [];
  final supabase = Supabase.instance.client;

  AdminNotificationController() {
    loadData();
  }

  List<AdminNotification> get notifications => List.unmodifiable(_notifications);
  int get totalCount => _notifications.length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final List<AdminNotification> result = [];

      // ── KOST pending + owner name ──────────────────────────────────────
      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost, owner_id, profiles(username)')
          .eq('status', 'pending')
          .order('id_kost', ascending: false);

      for (var k in (kostRes as List)) {
        final idKost = k['id_kost'].toString();
        final namaKost = k['nama_kost'] as String? ?? '-';
        final ownerName = (k['profiles'] as Map?)?['username'] as String? ?? '-';

        result.add(AdminNotification(
          id: 'kost_pending_$idKost',
          title: 'Pengajuan Kost Baru',
          description: '$namaKost menunggu verifikasi admin.',
          time: '',
          type: AdminNotificationType.kostApproval,
          targetName: namaKost,
          actionLabel: 'Cek approval kost',
          ownerName: ownerName,
        ));
      }

      // ── JASA pending + owner name ──────────────────────────────────────
      final jasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa, owner_id, profiles(username)')
          .eq('status', 'pending')
          .order('id_jasa', ascending: false);

      for (var j in (jasaRes as List)) {
        final idJasa = j['id_jasa'].toString();
        final namaJasa = j['nama_jasa'] as String? ?? '-';
        final ownerName = (j['profiles'] as Map?)?['username'] as String? ?? '-';

        result.add(AdminNotification(
          id: 'jasa_pending_$idJasa',
          title: 'Pengajuan Jasa Baru',
          description: '$namaJasa menunggu verifikasi admin.',
          time: '',
          type: AdminNotificationType.jasaApproval,
          targetName: namaJasa,
          actionLabel: 'Cek approval jasa',
          ownerName: ownerName,
        ));
      }

      _notifications
        ..clear()
        ..addAll(result);
    } catch (e) {
      debugPrint('Error loading admin notifikasi: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}