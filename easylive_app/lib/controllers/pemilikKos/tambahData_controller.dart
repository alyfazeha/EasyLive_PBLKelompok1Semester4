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

  @Deprecated('Gunakan selectedPhotosBytes untuk kompatibilitas Flutter Web')
  List<File> selectedPhotos = [];

  final supabase = Supabase.instance.client;

  Future<void> simpanData(BuildContext context) async {
    try {
      // Get logged in user
      final user = supabase.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User is not logged in")));
        return;
      }

      // Insert data into kost table
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
        'kamar_kosong': int.parse(kamarKosong.text),
        'tipe_kost': tipeKost,
        'status': 'pending',
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kost data saved successfully")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
