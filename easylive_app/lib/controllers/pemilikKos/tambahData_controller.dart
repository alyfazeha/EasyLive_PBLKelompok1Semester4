import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahDataController {
  final TextEditingController namaKost = TextEditingController();
  final TextEditingController nomorHp = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController kecamatan = TextEditingController();
  final TextEditingController kota = TextEditingController();
  final TextEditingController jumlahKamar = TextEditingController();
  final TextEditingController kamarKosong = TextEditingController();
  final TextEditingController harga = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();

  String tipeKost = '';

  List<Uint8List> selectedPhotosBytes = [];
  List<File> selectedPhotos = [];

  final supabase = Supabase.instance.client;

  /// Memastikan controller dihapus dari memori saat tidak digunakan
  void dispose() {
    namaKost.dispose();
    nomorHp.dispose();
    alamat.dispose();
    kecamatan.dispose();
    kota.dispose();
    jumlahKamar.dispose();
    kamarKosong.dispose();
    harga.dispose();
    deskripsi.dispose();
  }

  Future<void> simpanData(BuildContext context, List<String> fasilitasLabels) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User is not logged in")));
        return;
      }

      List<String> fotoUrls = [];

      for (int i = 0; i < selectedPhotosBytes.length; i++) {
        final bytes = selectedPhotosBytes[i];
        if (bytes.isEmpty) continue;

        final fileName =
            '${user.id}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage.from('kost-images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        final publicUrl =
            supabase.storage.from('kost-images').getPublicUrl(fileName);

        fotoUrls.add(publicUrl);
      }

      await supabase.from('kost').insert({
        'owner_id': user.id,
        'nama_kost': namaKost.text,
        'harga': double.tryParse(harga.text) ?? 0,
        'deskripsi': deskripsi.text,
        'nomor_hp': nomorHp.text,
        'alamat': alamat.text,
        'kecamatan': kecamatan.text,
        'kota': kota.text,
        'jumlah_kamar': int.tryParse(jumlahKamar.text) ?? 0,
        'kamar_kosong': int.tryParse(kamarKosong.text) ?? 0,
        'tipe_kost': tipeKost,
        'status': 'pending',
        'gambar': fotoUrls,
        'fasilitas': fasilitasLabels,
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kost data saved successfully")));

    } catch (e, stackTrace) {
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}