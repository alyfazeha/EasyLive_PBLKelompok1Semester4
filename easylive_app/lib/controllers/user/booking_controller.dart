import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user/booking_model.dart';

class BookingController {
  /// Mapping label UI -> status_pesanan di `booking_kos`.
  ///
  /// Dari jawaban kamu:
  /// - Active Now => dikonfirmasi
  /// - Completed => selesai
  /// - Canceled => ditolak
  static String? _mapUiStatusToDb(String uiStatus) {
    switch (uiStatus) {
      case 'Active Now':
        return 'dikonfirmasi';
      case 'Completed':
        return 'selesai';
      case 'Canceled':
        return 'ditolak';
      default:
        return null;
    }
  }

  static String getEmptyMessage(String status) {
    switch (status) {
      case 'Completed':
        return 'You have no completed booking';
      case 'Canceled':
        return 'You have no canceled booking';
      default:
        return 'You have no active booking';
    }
  }

  /// Ambil booking kos milik user yang sedang login.
  ///
  /// Schema (dari DDL kamu):
  /// - booking_kos: id_profile, id_kost, total_bayar, tanggal_checkin, status_pesanan
  /// - kost: id_kost, nama_kost, alamat, harga, (kolom gambar dst)
  static Future<List<Booking>> fetchBookingsForLoggedInUser({
    required String selectedType,
    required String selectedStatus,
    required String searchQuery,
  }) async {
    if (selectedType != 'Kost') {
      // Supabase schema yang kamu kirim baru booking_kos.
      return [];
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final dbStatus = _mapUiStatusToDb(selectedStatus);
    if (dbStatus == null) return [];

    final supabase = Supabase.instance.client;

    final res = await supabase
        .from('booking_kos')
        .select('''
          id_booking_kost,
          id_profile,
          id_kost,
          total_bayar,
          status_pesanan,
          tanggal_checkin,
          kost (
            id_kost,
            nama_kost,
            alamat,
            harga
          )
        ''')
        .eq('id_profile', user.id)
        .eq('status_pesanan', dbStatus)
        .order('tanggal_checkin', ascending: false);

    final list = (res as List?) ?? <dynamic>[];

    final q = searchQuery.trim().toLowerCase();

    List<Booking> bookings = list
        .map<Booking>((item) {
          final kost = item['kost'] ?? {};

          final title = (kost['nama_kost'] ?? '').toString();
          final location = (kost['alamat'] ?? '').toString();

          // total_bayar bertipe numeric. Kita format jadi rupiah sederhana.
          final totalRaw = item['total_bayar'];
          final totalInt = totalRaw is num
              ? totalRaw.toInt()
              : int.tryParse(totalRaw?.toString() ?? '');

          final price = totalInt == null
              ? '-'
              : 'Rp ${totalInt.toString().replaceAllMapped(RegExp(r"\\B(?=(\\d{3})+(?!\\d))"), (m) => '.')}';

          // tanggal_checkin bertipe date (YYYY-MM-DD). Kita tampilkan sebagai string.
          final tanggal = item['tanggal_checkin'];
          final dateStr = tanggal == null
              ? '—'
              : (tanggal is String ? tanggal : tanggal.toString());

          return Booking(
            title: title,
            location: location,
            price: price,
            type: 'Kost',
            status: selectedStatus,
            date: dateStr,
            rawStatus: item['status_pesanan']?.toString(),
          );
        })
        .where((b) {
          if (q.isEmpty) return true;
          return b.title.toLowerCase().contains(q) ||
              b.location.toLowerCase().contains(q);
        })
        .toList();

    return bookings;
  }
}
