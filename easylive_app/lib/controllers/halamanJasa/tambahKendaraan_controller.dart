import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahKendaraanController {
  final supabase = Supabase.instance.client;

  TextEditingController namaKendaraan = TextEditingController();
  TextEditingController nomorHp = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController nomorPlat = TextEditingController();
  TextEditingController kapasitas = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  String tipeKendaraan = '';

  /// Foto kendaraan (maks 3)
  final List<Uint8List> selectedPhotosBytes = [];
  final List<File> selectedPhotos = [];

  void setFoto({
    required int slotIndex,
    required Uint8List bytes,
    required File file,
  }) {
    // Maintain bytes list size up to slotIndex
    while (selectedPhotosBytes.length < slotIndex) {
      selectedPhotosBytes.add(Uint8List(0));
    }

    if (selectedPhotosBytes.length == slotIndex) {
      selectedPhotosBytes.add(bytes);
    } else {
      selectedPhotosBytes[slotIndex] = bytes;
    }

    // Remove empties
    selectedPhotosBytes.removeWhere((b) => b.isEmpty);

    // Max 3
    if (selectedPhotosBytes.length > 3) {
      selectedPhotosBytes.removeRange(3, selectedPhotosBytes.length);
    }

    // Maintain file list size up to slotIndex
    while (selectedPhotos.length < slotIndex) {
      selectedPhotos.add(File(''));
    }

    if (selectedPhotos.length == slotIndex) {
      selectedPhotos.add(file);
    } else {
      selectedPhotos[slotIndex] = file;
    }

    selectedPhotos.removeWhere((f) => f.path.isEmpty);

    if (selectedPhotos.length > 3) {
      selectedPhotos.removeRange(3, selectedPhotos.length);
    }
  }

  Future<void> simpanData(BuildContext context) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not logged in')),
        );
        return;
      }

      final List<String> fotoUrls = [];

      for (int i = 0; i < selectedPhotosBytes.length; i++) {
        final bytes = selectedPhotosBytes[i];
        if (bytes.isEmpty) continue;

        final fileName =
            '${user.id}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage.from('jasa-images').uploadBinary(
              fileName,
              bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );

        final publicUrl =
            supabase.storage.from('jasa-images').getPublicUrl(fileName);
        fotoUrls.add(publicUrl);
      }

      await supabase.from('jasa').insert({
      'owner_id': user.id,
      'nama_jasa': namaKendaraan.text,        // ← nama kolom di DDL
      'tipe_mobil': tipeKendaraan,            // ← nama kolom di DDL
      'price_km': double.tryParse(harga.text) ?? 0, // ← nama kolom di DDL
      'price_mobil': 0,                       // ← wajib isi karena NOT NULL
      'alamat': alamat.text,
      'kecamatan': kecamatan.text,
      'kota': kota.text,
      'nomor_plat': nomorPlat.text,
      'kapasitas': kapasitas.text,
      'nomor_hp': nomorHp.text,
      'deskripsi': deskripsi.text,
      'status': 'pending',
      'gambar': fotoUrls,
    });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendaraan tersimpan')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error menyimpan: $e')),
      );
    }
  }
}

