import 'dart:io';

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

<<<<<<< HEAD
  /// Simpan path foto yang dipilih (max 3)
  final List<File> selectedPhotos = [];

  void setPhoto(int index, File file) {
    // Pastikan list panjangnya minimal sesuai index
    while (selectedPhotos.length < index) {
      selectedPhotos.add(File(''));
    }

    if (selectedPhotos.length == index) {
      selectedPhotos.add(file);
      return;
    }

    selectedPhotos[index] = file;
  }

  void addPhoto(File file) {
    if (selectedPhotos.length >= 3) return;
    selectedPhotos.add(file);
  }

  int get photosCount => selectedPhotos.length;

  void simpanData(BuildContext context) {
    // Demo: print data and show success
    print("Nama Kost: ${namaKost.text}");
    print("Nomor HP: ${nomorHp.text}");
    print("Kost Type: $tipeKost");
    print("Jumlah foto terpilih: ${selectedPhotos.length}");
=======
  final supabase = Supabase.instance.client;
>>>>>>> 191d8aaac5305d62bae2515ba5162cab5f81dd18

  Future<void> simpanData(BuildContext context) async {
    try {
      // Get logged in user
      final user = supabase.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User is not logged in")),
        );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kost data saved successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }
}