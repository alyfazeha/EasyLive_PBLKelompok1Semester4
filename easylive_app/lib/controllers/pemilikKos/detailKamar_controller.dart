import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/detailKamar_models.dart';

class KostController {
  final supabase = Supabase.instance.client;

  Future<Kost> getKostDetail(String idKost) async {
    try {
      final res = await supabase
          .from('kost')
          .select()
          .eq('id_kost', int.parse(idKost))
          .single();

      final gambar = (res['gambar'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final fasilitas = (res['fasilitas'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final harga = (res['harga'] as num?)?.toDouble() ?? 0;
      final jumlahKamar = (res['jumlah_kamar'] as int?) ?? 0;
      final kamarKosong = (res['kamar_kosong'] as int?) ?? 0;

      return Kost(
        idKost: res['id_kost'].toString(),
        name: res['nama_kost'] ?? '-',
        address: res['alamat'] ?? '-',
        totalRoom: jumlahKamar,
        availableRoom: kamarKosong,
        price: 'Rp ${_formatHarga(harga)} / bulan',
        description: res['deskripsi'] ?? '-',
        images: gambar.isNotEmpty ? gambar : ['assets/images/kos1.jpg'],
        facilities: fasilitas,
        tipeKost: res['tipe_kost'] ?? '-',
      );
    } catch (e, stack) {
      print('ERROR getKostDetail: $e');
      print('STACK: $stack');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsByKostId(String idKost) async {
    try {
      final bookings = await supabase
          .from('booking_kost')
          .select('id_booking_kost')
          .eq('id_kost', int.parse(idKost))
          .eq('status_pesanan', 'selesai');

      if (bookings.isEmpty) return [];

      final bookingIds = bookings
          .map((b) => b['id_booking_kost'] as int)
          .toList();

      final reviews = await supabase
          .from('reviews')
          .select('ulasan, rating, id_profile, profiles(nama)')
          .inFilter('id_booking_kost', bookingIds)
          .not('rating', 'is', null);

      return List<Map<String, dynamic>>.from(reviews);
    } catch (e, stack) {
      print('ERROR getReviewsByKostId: $e');
      print('STACK: $stack');
      return [];
    }
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