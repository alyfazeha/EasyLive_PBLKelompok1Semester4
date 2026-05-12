import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/detailKamar_models.dart';

class KostController {
  final supabase = Supabase.instance.client;

  Future<Kost> getKostDetail(String idKost) async {
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