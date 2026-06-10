import 'package:supabase_flutter/supabase_flutter.dart';

class DuitkuService {
  static final _supabase = Supabase.instance.client;

  /// Membuat booking_kos di Supabase lalu membuat invoice Duitku.
  ///
  /// Returns: Map berisi 'paymentUrl' dan 'reference'
  static Future<Map<String, dynamic>> createBookingAndInvoice({
    required int idKost,
    required String namaKost,
    required int hargaKost,
    required String namaPemesan,
    required String nomorHP,
    required DateTime tanggalCheckin,
  }) async {
    const double biayaLayanan = 25000;
    final int totalBayar = hargaKost + biayaLayanan.toInt();

    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login');

    // --------------------------------------------------
    // 1. Insert ke tabel booking_kos
    // --------------------------------------------------
    final bookingRes = await _supabase
        .from('booking_kos')
        .insert({
          'id_profile': user.id,
          'id_kost': idKost,
          'total_bayar': totalBayar,
          'tanggal_checkin':
              '${tanggalCheckin.year}-${tanggalCheckin.month.toString().padLeft(2, '0')}-${tanggalCheckin.day.toString().padLeft(2, '0')}',
          'status_pesanan': 'menunggu',
        })
        .select()
        .single();

    final int idBookingKost = bookingRes['id_booking_kost'];

    // --------------------------------------------------
    // 2. Panggil Edge Function create-duitku-invoice
    // --------------------------------------------------
    final merchantOrderId = 'KOS-${DateTime.now().millisecondsSinceEpoch}';

    final res = await _supabase.functions.invoke(
      'create-duitku-invoice',
      body: {
        'merchantOrderId': merchantOrderId,
        'paymentAmount': totalBayar,
        'productDetails': 'Booking $namaKost',
        'customerName': namaPemesan,
        'customerEmail': user.email ?? 'customer@email.com',
        'customerPhone': nomorHP,
        'idBookingKost': idBookingKost,
      },
    );

    if (res.status != 200) {
      // Rollback booking jika invoice gagal dibuat
      await _supabase
          .from('booking_kos')
          .delete()
          .eq('id_booking_kost', idBookingKost);
      throw Exception('Gagal membuat invoice: ${res.data}');
    }

    final data = res.data as Map<String, dynamic>;
    return {
      'paymentUrl': data['paymentUrl'],
      'reference': data['reference'],
      'idBookingKost': idBookingKost,
    };
  }

  /// Cek status pembayaran berdasarkan reference Duitku
  static Future<String> checkPaymentStatus(String reference) async {
    final res = await _supabase
        .from('payments')
        .select('status')
        .eq('id_transaction', reference)
        .single();

    return res['status'] ?? 'pending';
  }
}
