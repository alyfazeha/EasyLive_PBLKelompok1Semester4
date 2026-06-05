import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikJasa/detail_jasa_model.dart';

class DetailJasaController {
  final supabase = Supabase.instance.client;

  // Masih dipakai oleh EditKendaraanView lama — akan diganti nanti
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
      price: 'Rp ${_formatHarga(hargaKm)} / km',
      description: res['deskripsi'] ?? '-',
      images: gambar,
      status: res['status'] ?? 'pending',
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