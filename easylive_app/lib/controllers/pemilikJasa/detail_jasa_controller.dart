import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikJasa/detail_jasa_model.dart';

class DetailJasaController {
  final supabase = Supabase.instance.client;

  DetailJasa getJasaDetail(String vehicleName) {
    return DetailJasa(
      idJasa: '',
      name: vehicleName,
      address: '-',
      kecamatan: '-',
      kota: '-',
      nomorHp: '-',
      nomorPlat: '-',
      kapasitas: '-',
      tipeMobil: '-',
      totalVehicle: 0,
      price: '-',
      description: '-',
      images: [],
      status: 'pending',
    );
  }

  Future<DetailJasa> getJasaDetailById(String idJasa) async {
    try {
      final res = await supabase
          .from('jasa')
          .select()
          .eq('id_jasa', int.parse(idJasa))
          .single();

      final gambar = (res['gambar'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final hargaKm = (res['price_km'] as num?)?.toDouble() ?? 0;

      return DetailJasa(
        idJasa: res['id_jasa'].toString(),
        name: res['nama_jasa'] ?? '-',
        address: res['alamat'] ?? '-',
        kecamatan: res['kecamatan'] ?? '-',
        kota: res['kota'] ?? '-',
        nomorHp: res['nomor_hp'] ?? '-',
        nomorPlat: res['nomor_plat'] ?? '-',
        kapasitas: res['kapasitas'] ?? '-',
        tipeMobil: res['tipe_mobil'] ?? '-',
        totalVehicle: 0,
        price: 'Rp ${_formatHarga(hargaKm)}',
        description: res['deskripsi'] ?? '-',
        images: gambar,
        status: res['status'] ?? 'pending',
      );
    } catch (e, stack) {
      print('ERROR getJasaDetailById: $e');
      print('STACK: $stack');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsByJasaId(String idJasa) async {
    try {
      final bookings = await supabase
          .from('booking_jasa')
          .select('id_booking_jasa')
          .eq('id_jasa', int.parse(idJasa))
          .eq('status_pesanan', 'selesai');

      if (bookings.isEmpty) return [];

      final bookingIds = bookings
          .map((b) => b['id_booking_jasa'] as int)
          .toList();

      final reviews = await supabase
          .from('reviews')
          .select('ulasan, rating, id_profile, profiles(username)')
          .inFilter('id_booking_jasa', bookingIds)
          .not('rating', 'is', null);

      return List<Map<String, dynamic>>.from(reviews);
    } catch (e, stack) {
      print('ERROR getReviewsByJasaId: $e');
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