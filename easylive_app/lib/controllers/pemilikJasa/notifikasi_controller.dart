import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikJasa/notifikasi_model.dart';

class OwnerJasaNotificationController extends ChangeNotifier {
  bool isLoading = false;
  final List<OwnerNotification> _notifications = [];
  final supabase = Supabase.instance.client;

  OwnerJasaNotificationController() {
    loadData();
  }

  List<OwnerNotification> get notifications => _notifications;
  int get totalCount => _notifications.length;

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

      // 1️⃣ Jasa disetujui/ditolak admin
      final jasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa, status')
          .eq('owner_id', user.id)
          .inFilter('status', ['aktif', 'ditolak']);

      for (var j in (jasaRes as List)) {
        final status = j['status'] as String;
        final namaJasa = j['nama_jasa'] ?? '-';
        final idJasa = j['id_jasa'].toString();

        if (status == 'aktif') {
          result.add(OwnerNotification(
            id: 'jasa_approved_$idJasa',
            title: 'Jasa Disetujui Admin',
            description: '$namaJasa telah disetujui\ndan sekarang aktif',
            time: '',
            type: OwnerNotificationType.approved,
          ));
        } else if (status == 'ditolak') {
          result.add(OwnerNotification(
            id: 'jasa_rejected_$idJasa',
            title: 'Jasa Ditolak Admin',
            description: '$namaJasa ditolak oleh admin',
            time: '',
            type: OwnerNotificationType.rejected,
          ));
        }
      }

      // 2️⃣ Ambil SEMUA jasa (termasuk pending) untuk booking & payment
      final allJasaRes = await supabase
          .from('jasa')
          .select('id_jasa, nama_jasa')
          .eq('owner_id', user.id);

      final Map<int, String> allJasaNames = {
        for (var j in (allJasaRes as List))
          (j['id_jasa'] as int): (j['nama_jasa'] as String? ?? '-')
      };

      final allJasaIds = allJasaNames.keys.toList();

      if (allJasaIds.isNotEmpty) {
        // 3️⃣ Booking menunggu yang sudah bayar
        final bookingRes = await supabase
            .from('booking_jasa')
            .select('id_booking_jasa, id_jasa, id_profile, status_pesanan')
            .inFilter('id_jasa', allJasaIds)
            .eq('status_pesanan', 'menunggu')
            .order('id_booking_jasa', ascending: false);

        final bookingResIds = (bookingRes as List)
            .map((b) => b['id_booking_jasa'] as int)
            .toList();

        // Cek mana yang sudah settlement
        Set<int> paidBookingIds = {};
        if (bookingResIds.isNotEmpty) {
          final paidRes = await supabase
              .from('payments')
              .select('id_booking_jasa')
              .inFilter('id_booking_jasa', bookingResIds)
              .eq('status', 'settlement');

          paidBookingIds = {
            for (var p in (paidRes as List))
              p['id_booking_jasa'] as int
          };
        }

        // Ambil nama penyewa
        final profileIds = bookingRes
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
          final idBooking = b['id_booking_jasa'] as int;

          // ← hanya tampilkan yang sudah bayar
          if (!paidBookingIds.contains(idBooking)) continue;

          final idJasa = b['id_jasa'] as int;
          final idProfile = b['id_profile'] as String? ?? '';
          final nama = profileNames[idProfile] ?? '-';
          final namaJasa = allJasaNames[idJasa] ?? '-';

          result.add(OwnerNotification(
            id: 'booking_$idBooking',
            title: 'Booking Baru',
            description: 'Ada booking baru dari $nama\nuntuk jasa $namaJasa',
            time: '',
            type: OwnerNotificationType.booking,
          ));
        }

        // 4️⃣ Pembayaran berhasil (settlement) — semua booking
        final allBookingRes = await supabase
            .from('booking_jasa')
            .select('id_booking_jasa, id_profile, id_jasa')
            .inFilter('id_jasa', allJasaIds);

        final bookingIds = (allBookingRes as List)
            .map((b) => b['id_booking_jasa'] as int)
            .toList();

        final Map<int, Map<String, dynamic>> bookingDetails = {
          for (var b in allBookingRes)
            (b['id_booking_jasa'] as int): b
        };

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
              .select('id_payments, id_booking_jasa, gross_amount')
              .inFilter('id_booking_jasa', bookingIds)
              .eq('status', 'settlement');

          for (var p in (paymentRes as List)) {
            final idPayment = p['id_payments'].toString();
            final idBooking = p['id_booking_jasa'] as int;
            final grossAmount =
                (p['gross_amount'] as num?)?.toDouble() ?? 0;
            final booking = bookingDetails[idBooking];
            final idProfile = booking?['id_profile'] as String? ?? '';
            final idJasa = booking?['id_jasa'] as int?;
            final nama = allProfileNames[idProfile] ?? '-';
            final namaJasa =
                idJasa != null ? (allJasaNames[idJasa] ?? '-') : '-';

            result.add(OwnerNotification(
              id: 'payment_$idPayment',
              title: 'Pembayaran Berhasil',
              description:
                  'Pembayaran dari $nama\nuntuk jasa $namaJasa\nsebesar Rp ${_formatHarga(grossAmount)}',
              time: '',
              type: OwnerNotificationType.payment,
            ));
          }
        }
      }

      _notifications.clear();
      _notifications.addAll(result);
    } catch (e) {
      debugPrint('Error loading jasa notifikasi: $e');
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