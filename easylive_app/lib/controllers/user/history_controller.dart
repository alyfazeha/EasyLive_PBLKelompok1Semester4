import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/history_model.dart';

class HistoryController {
  static const List<String> historyTypes = ['Kost', 'Jasa'];
  static const String defaultType = 'Kost';

  static final _supabase = Supabase.instance.client;

  // ─── History ────────────────────────────────────────────────────────────────

  static Future<List<HistoryItem>> fetchAllHistories() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final results = await Future.wait([
      fetchKostHistories(userId),
      fetchJasaHistories(userId),
    ]);
    return [...results[0], ...results[1]];
  }

  static Future<List<HistoryItem>> fetchKostHistories(String userId) async {
    try {
      final response = await _supabase
          .from('booking_kos')
          .select('''
            id_booking_kost,
            total_bayar,
            tanggal_checkin,
            status_pesanan,
            kost (
              nama_kost,
              alamat,
              owner:owner_id (
                full_name
              )
            ),
            profiles (
              full_name
            )
          ''')
          .eq('id_profile', userId)
          .eq('status_pesanan', 'selesai')
          .order('tanggal_checkin', ascending: false);

      return (response as List)
          .map((row) => HistoryItem.fromKostRow(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<HistoryItem>> fetchJasaHistories(String userId) async {
    try {
      final response = await _supabase
          .from('booking_jasa')
          .select('''
            id_booking_jasa,
            titik_penjemputan,
            total_bayar,
            status_pesanan,
            tanggal,
            bulan,
            jasa (
              nama_jasa,
              owner:owner_id (
                full_name
              )
            ),
            profiles (
              full_name
            )
          ''')
          .eq('id_profile', userId)
          .eq('status_pesanan', 'selesai')
          .order('bulan', ascending: false);

      return (response as List)
          .map((row) => HistoryItem.fromJasaRow(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static List<HistoryItem> filterByType(List<HistoryItem> items, String type) {
    return items.where((item) => item.type == type).toList();
  }

  // ─── Review ─────────────────────────────────────────────────────────────────

  /// Cek apakah user sudah pernah review booking ini.
  /// Kembalikan Map review jika sudah ada, null jika belum.
  static Future<Map<String, dynamic>?> fetchExistingReview(HistoryItem item) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final column = item.type == 'Kost' ? 'id_booking_kost' : 'id_booking_jasa';
      final response = await _supabase
          .from('reviews')
          .select('id_review, rating, ulasan')
          .eq('id_profile', userId)
          .eq(column, item.bookingId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  /// Submit review baru. Kembalikan true jika berhasil.
  static Future<bool> submitReview({
    required HistoryItem item,
    required int rating,
    required String ulasan,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final payload = <String, dynamic>{
        'id_profile': userId,
        'rating': rating,
        'ulasan': ulasan.trim(),
        // Salah satu diisi, yang lain null sesuai tipe
        if (item.type == 'Kost') 'id_booking_kost': item.bookingId,
        if (item.type == 'Jasa') 'id_booking_jasa': item.bookingId,
      };

      await _supabase.from('reviews').insert(payload);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ─── Util ────────────────────────────────────────────────────────────────────

  static String formatHistoryDate(DateTime value) {
    const dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final dayName = dayNames[value.weekday - 1];
    final monthName = monthNames[value.month - 1];
    return '$hour:$minute, $dayName, ${value.day} $monthName ${value.year}';
  }
}