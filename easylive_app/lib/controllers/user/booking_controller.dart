import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/booking_model.dart';

class BookingController {
  static String? _mapUiStatusToDb(String uiStatus) {
    switch (uiStatus) {
      case 'Active Now':
        return 'dikonfirmasi';
      case 'Pending':
        return 'menunggu';
      case 'Canceled':
        return 'ditolak';
      default:
        return null;
    }
  }

  static String getEmptyMessage(String status) {
    switch (status) {
      case 'Pending':
        return 'You have no pending booking';
      case 'Canceled':
        return 'You have no canceled booking';
      default:
        return 'You have no active booking';
    }
  }

  static String _formatRupiah(int amount) {
    final str = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result.write('.');
      result.write(str[i]);
    }
    return 'Rp $result,-';
  }

  static Future<List<Booking>> fetchBookingsForLoggedInUser({
    required String selectedType,
    required String selectedStatus,
    required String searchQuery,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final dbStatus = _mapUiStatusToDb(selectedStatus);
    if (dbStatus == null) return [];

    final supabase = Supabase.instance.client;
    final q = searchQuery.trim().toLowerCase();

    if (selectedType == 'Kost') {
      final res = await supabase
          .from('booking_kos')
          .select('''
            id_booking_kost,
            total_bayar,
            status_pesanan,
            tanggal_checkin,
            kost (
              nama_kost,
              alamat,
              harga
            )
          ''')
          .eq('id_profile', user.id)
          .eq('status_pesanan', dbStatus)
          .order('tanggal_checkin', ascending: false);

      return ((res as List?) ?? [])
          .map<Booking>((item) {
            final kost = item['kost'] ?? {};
            final title = (kost['nama_kost'] ?? '').toString();
            final location = (kost['alamat'] ?? '').toString();
            final totalInt = (item['total_bayar'] as num?)?.toInt();
            final price = totalInt == null ? '-' : _formatRupiah(totalInt);
            final dateStr = item['tanggal_checkin']?.toString() ?? '—';

            return Booking(
              title: title,
              location: location,
              price: price,
              type: 'Kost',
              status: selectedStatus,
              date: dateStr,
              rawStatus: item['status_pesanan']?.toString(),
              alasanPenolakan: item['alasan_penolakan']?.toString(), // ← tambah ini
              idBooking: item['id_booking_kost'],                    // ← tambah ini
            );
          })
          .where((b) =>
              q.isEmpty ||
              b.title.toLowerCase().contains(q) ||
              b.location.toLowerCase().contains(q))
          .toList();
    } else {
      final res = await supabase
          .from('booking_jasa')
          .select('''
            id_booking_jasa,
            total_bayar,
            status_pesanan,
            titik_penjemputan,
            titik_tujuan,
            tanggal,
            bulan,
            jasa (
              nama_jasa
            )
          ''')
          .eq('id_profile', user.id)
          .eq('status_pesanan', dbStatus)
          .order('id_booking_jasa', ascending: false);

      return ((res as List?) ?? [])
          .map<Booking>((item) {
            final jasa = item['jasa'] ?? {};
            final title = (jasa['nama_jasa'] ?? '').toString();
            final from = (item['titik_penjemputan'] ?? '').toString();
            final to = (item['titik_tujuan'] ?? '').toString();
            final location = '$from → $to';
            final totalInt = (item['total_bayar'] as num?)?.toInt();
            final price = totalInt == null ? '-' : _formatRupiah(totalInt);
            final dateStr = '${item['tanggal'] ?? '-'}/${item['bulan'] ?? '-'}';

            return Booking(
              title: title,
              location: location,
              price: price,
              type: 'Jasa',
              status: selectedStatus,
              date: dateStr,
              rawStatus: item['status_pesanan']?.toString(),
              idBooking: item['id_booking_jasa'],
            );
          })
          .where((b) =>
              q.isEmpty ||
              b.title.toLowerCase().contains(q) ||
              b.location.toLowerCase().contains(q))
          .toList();
    }
  }
}