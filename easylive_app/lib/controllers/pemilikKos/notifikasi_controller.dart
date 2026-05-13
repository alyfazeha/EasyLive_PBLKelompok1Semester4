import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/notifikasi_model.dart';

class OwnerNotificationController extends ChangeNotifier {
  bool showUnreadOnly = false;
  bool isLoading = false;

  final List<OwnerNotification> _notifications = [];
  final supabase = Supabase.instance.client;

  OwnerNotificationController() {
    loadData();
  }

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

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final List<OwnerNotification> result = [];

      // 1️⃣ Kost approved/ditolak admin
      final kostRes = await supabase
          .from('kost')
          .select('id_kost, nama_kost, status, alasan_tolak')
          .eq('owner_id', user.id)
          .inFilter('status', ['aktif', 'ditolak']);

      final Map<int, String> kostNames = {
        for (var k in (kostRes as List))
          (k['id_kost'] as int): (k['nama_kost'] as String? ?? '-')
      };

      for (var k in (kostRes as List)) {
        final status = k['status'] as String;
        final namaKost = k['nama_kost'] ?? '-';
        final idKost = k['id_kost'].toString();
        final alasan = k['alasan_tolak'] as String?;

        if (status == 'aktif') {
          result.add(OwnerNotification(
            id: 'kost_approved_$idKost',
            title: 'Kost Disetujui Admin',
            description: '$namaKost telah disetujui\ndan sekarang aktif',
            time: '',
            type: OwnerNotificationType.approved,
          ));
        } else if (status == 'ditolak') {
          result.add(OwnerNotification(
            id: 'kost_rejected_$idKost',
            title: 'Kost Ditolak Admin',
            description: '$namaKost ditolak admin'
                '${alasan != null ? '\nAlasan: $alasan' : ''}',
            time: '',
            type: OwnerNotificationType.rejected,
          ));
        }
      }

      // 2️⃣ Booking kos yang menunggu konfirmasi
      final kostIds = kostNames.keys.toList();

      if (kostIds.isNotEmpty) {
        final bookingRes = await supabase
            .from('booking_kos')
            .select('id_booking_kost, id_kost, id_profile, status_pesanan, tanggal_checkin')
            .inFilter('id_kost', kostIds)
            .eq('status_pesanan', 'menunggu') // ← hanya menunggu
            .order('id_booking_kost', ascending: false);

        // Ambil nama penyewa
        final profileIds = (bookingRes as List)
            .map((b) => b['id_profile'] as String?)
            .where((id) => id != null)
            .toSet()
            .toList();

        Map<String, String> profileNames = {};
        if (profileIds.isNotEmpty) {
          final profileRes = await supabase
              .from('profiles')
              .select('id_profile, username')
              .inFilter('id_profile', profileIds);

          profileNames = {
            for (var p in (profileRes as List))
              (p['id_profile'] as String): (p['username'] as String? ?? '-')
          };
        }

        for (var b in bookingRes) {
          final idBooking = b['id_booking_kost'].toString();
          final idKost = b['id_kost'] as int;
          final idProfile = b['id_profile'] as String? ?? '';
          final nama = profileNames[idProfile] ?? '-';
          final namaKost = kostNames[idKost] ?? '-';

          result.add(OwnerNotification(
            id: 'booking_$idBooking',
            title: 'Booking Baru',
            description: 'Ada booking baru dari $nama\ndi $namaKost',
            time: '',
            type: OwnerNotificationType.booking,
          ));
        }

        // 3️⃣ Payments settlement
        final allBookingRes = await supabase
            .from('booking_kos')
            .select('id_booking_kost, id_profile')
            .inFilter('id_kost', kostIds);

        final bookingIds = (allBookingRes as List)
            .map((b) => b['id_booking_kost'] as int)
            .toList();

        final Map<int, String> bookingToProfile = {
          for (var b in allBookingRes)
            (b['id_booking_kost'] as int): (b['id_profile'] as String? ?? '')
        };

        // Ambil nama penyewa untuk semua booking (termasuk yang sudah bayar)
        final allProfileIds = allBookingRes
            .map((b) => b['id_profile'] as String?)
            .where((id) => id != null)
            .toSet()
            .toList();

        Map<String, String> allProfileNames = {};
        if (allProfileIds.isNotEmpty) {
          final allProfileRes = await supabase
              .from('profiles')
              .select('id_profile, username')
              .inFilter('id_profile', allProfileIds);

          allProfileNames = {
            for (var p in (allProfileRes as List))
              (p['id_profile'] as String): (p['username'] as String? ?? '-')
          };
        }

        if (bookingIds.isNotEmpty) {
          final paymentRes = await supabase
              .from('payments')
              .select('id_payments, id_booking_kost, gross_amount, status')
              .inFilter('id_booking_kost', bookingIds)
              .eq('status', 'settlement');

          for (var p in (paymentRes as List)) {
            final idPayment = p['id_payments'].toString();
            final idBooking = p['id_booking_kost'] as int;
            final grossAmount = (p['gross_amount'] as num?)?.toDouble() ?? 0;
            final idProfile = bookingToProfile[idBooking] ?? '';
            final nama = allProfileNames[idProfile] ?? '-';

            result.add(OwnerNotification(
              id: 'payment_$idPayment',
              title: 'Pembayaran Berhasil',
              description: 'Pembayaran dari $nama\nsebesar Rp ${_formatHarga(grossAmount)}',
              time: '',
              type: OwnerNotificationType.payment,
            ));
          }
        }
      }

      _notifications.clear();
      _notifications.addAll(result);
    } catch (e) {
      debugPrint('Error loading notifikasi: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  String _formatHarga(double harga) {
    return harga
        .toInt()
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}