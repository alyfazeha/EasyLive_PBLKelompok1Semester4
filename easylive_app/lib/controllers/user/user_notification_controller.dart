import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/user_notification_model.dart';

class UserNotificationController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final List<UserNotification> _notifications = [];
  final supabase = Supabase.instance.client;

  UserNotificationController() {
    loadData();
  }

  List<UserNotification> get notifications => _notifications;
  int get totalCount => _notifications.length;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final List<UserNotification> result = [];

      // ─── 1. Booking KOS milik user ────────────────────────────────────────
      final bookingKosRes = await supabase
          .from('booking_kos')
          .select('id_booking_kost, id_kost, status_pesanan, alasan_penolakan')
          .eq('id_profile', user.id)
          .inFilter('status_pesanan', ['dikonfirmasi', 'ditolak', 'selesai'])
          .order('id_booking_kost', ascending: false);

      // Ambil nama kost untuk setiap booking
      final kosIds = (bookingKosRes as List)
          .map((b) => b['id_kost'] as int?)
          .where((id) => id != null)
          .toSet()
          .toList();

      Map<int, String> kosNames = {};
      if (kosIds.isNotEmpty) {
        final kosRes = await supabase
            .from('kost')
            .select('id_kost, nama_kost')
            .inFilter('id_kost', kosIds);

        kosNames = {
          for (var k in (kosRes as List))
            (k['id_kost'] as int): (k['nama_kost'] as String? ?? '-')
        };
      }

      for (var b in bookingKosRes) {
        final idBooking = b['id_booking_kost'].toString();
        final idKost = b['id_kost'] as int?;
        final status = b['status_pesanan'] as String;
        final alasan = b['alasan_penolakan'] as String?;
        final namaKost = idKost != null ? (kosNames[idKost] ?? '-') : '-';

        final type = _parseType(status);
        if (type == null) continue;

        result.add(UserNotification(
          id: 'kos_${idBooking}',
          title: _titleFromType(type),
          description: _descKos(type, namaKost, alasan),
          type: type,
          source: BookingSource.kos,
        ));
      }

      // ─── 2. Booking JASA milik user ───────────────────────────────────────
      final bookingJasaRes = await supabase
          .from('booking_jasa')
          .select('id_booking_jasa, id_jasa, status_pesanan')
          .eq('id_profile', user.id)
          .inFilter('status_pesanan', ['dikonfirmasi', 'ditolak', 'selesai'])
          .order('id_booking_jasa', ascending: false);

      final jasaIds = (bookingJasaRes as List)
          .map((b) => b['id_jasa'] as int?)
          .where((id) => id != null)
          .toSet()
          .toList();

      Map<int, String> jasaNames = {};
      if (jasaIds.isNotEmpty) {
        final jasaRes = await supabase
            .from('jasa')
            .select('id_jasa, nama_jasa')
            .inFilter('id_jasa', jasaIds);

        jasaNames = {
          for (var j in (jasaRes as List))
            (j['id_jasa'] as int): (j['nama_jasa'] as String? ?? '-')
        };
      }

      for (var b in bookingJasaRes) {
        final idBooking = b['id_booking_jasa'].toString();
        final idJasa = b['id_jasa'] as int?;
        final status = b['status_pesanan'] as String;
        final namaJasa = idJasa != null ? (jasaNames[idJasa] ?? '-') : '-';

        final type = _parseType(status);
        if (type == null) continue;

        result.add(UserNotification(
          id: 'jasa_${idBooking}',
          title: _titleFromType(type),
          description: _descJasa(type, namaJasa),
          type: type,
          source: BookingSource.jasa,
        ));
      }

      _notifications.clear();
      _notifications.addAll(result);
    } catch (e) {
      debugPrint('Error loading user notifikasi: $e');
      errorMessage = 'Gagal memuat notifikasi. Coba lagi.';
    }

    isLoading = false;
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  UserNotificationType? _parseType(String status) {
    switch (status) {
      case 'dikonfirmasi':
        return UserNotificationType.dikonfirmasi;
      case 'ditolak':
        return UserNotificationType.ditolak;
      case 'selesai':
        return UserNotificationType.selesai;
      default:
        return null;
    }
  }

  String _titleFromType(UserNotificationType type) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return 'Booking Dikonfirmasi';
      case UserNotificationType.ditolak:
        return 'Booking Ditolak';
      case UserNotificationType.selesai:
        return 'Booking Selesai';
    }
  }

  String _descKos(UserNotificationType type, String namaKost, String? alasan) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return 'Booking kos $namaKost kamu telah dikonfirmasi oleh pemilik.';
      case UserNotificationType.ditolak:
        final alasanText =
            (alasan != null && alasan.isNotEmpty) ? '\nAlasan: $alasan' : '';
        return 'Booking kos $namaKost kamu ditolak.$alasanText';
      case UserNotificationType.selesai:
        return 'Masa sewa kos $namaKost kamu telah selesai.';
    }
  }

  String _descJasa(UserNotificationType type, String namaJasa) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return 'Booking jasa $namaJasa kamu telah dikonfirmasi oleh driver.';
      case UserNotificationType.ditolak:
        return 'Booking jasa $namaJasa kamu ditolak.';
      case UserNotificationType.selesai:
        return 'Perjalanan menggunakan jasa $namaJasa telah selesai.';
    }
  }
}