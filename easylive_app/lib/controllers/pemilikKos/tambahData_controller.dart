import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahDataController {
  TextEditingController namaKost = TextEditingController();
  TextEditingController nomorHp = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController jumlahKamar = TextEditingController();
  TextEditingController kamarKosong = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  String tipeKost = '';

  List<Uint8List> selectedPhotosBytes = [];
  List<File> selectedPhotos = [];

  final supabase = Supabase.instance.client;

  Future<void> simpanData(BuildContext context, List<String> fasilitasLabels) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User is not logged in")));
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

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Kost data saved successfully")));

      // ❌ Hapus Navigator.pop di sini, biarkan view yang handle

    } catch (e, stackTrace) {
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}