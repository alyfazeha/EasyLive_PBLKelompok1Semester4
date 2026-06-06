import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditKendaraanController {
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
  List<String> existingPhotos = [];

  final supabase = Supabase.instance.client;

  Future<void> loadFromSupabase(String idJasa) async {
    try {
      final res = await supabase
          .from('jasa')
          .select()
          .eq('id_jasa', int.parse(idJasa))
          .single();

      namaKendaraan.text = res['nama_jasa'] ?? '';
      nomorHp.text = res['nomor_hp'] ?? '';
      alamat.text = res['alamat'] ?? '';
      kecamatan.text = res['kecamatan'] ?? '';
      kota.text = res['kota'] ?? '';
      nomorPlat.text = res['nomor_plat'] ?? '';
      kapasitas.text = res['kapasitas'] ?? '';
      harga.text = res['price_km'].toString();
      deskripsi.text = res['deskripsi'] ?? '';
      tipeKendaraan = res['tipe_mobil'] ?? '';

      existingPhotos = (res['gambar'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
    } catch (e) {
      debugPrint('Error loading jasa: $e');
    }
  }

  Future<void> simpanData(
    BuildContext context,
    String idJasa, {
    List<File> newPhotos = const [],
  }) async {
    try {
      // Ambil hanya existing photos yang masih ada (tidak dikosongkan)
      List<String> fotoUrls =
          existingPhotos.where((e) => e.isNotEmpty).toList();

      // Upload foto baru ke bucket jasa-images
      for (int i = 0; i < newPhotos.length; i++) {
        final file = newPhotos[i];
        final fileName =
            'jasa_${idJasa}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage.from('jasa-images').uploadBinary(
              fileName,
              await file.readAsBytes(),
              fileOptions: const FileOptions(contentType: 'image/*'),
            );

        final publicUrl =
            supabase.storage.from('jasa-images').getPublicUrl(fileName);
        fotoUrls.add(publicUrl);
      }

      // Batasi max 3 foto
      if (fotoUrls.length > 3) {
        fotoUrls = fotoUrls.sublist(0, 3);
      }

      await supabase.from('jasa').update({
        'nama_jasa': namaKendaraan.text,
        'nomor_hp': nomorHp.text,
        'tipe_mobil': tipeKendaraan,
        'alamat': alamat.text,
        'kecamatan': kecamatan.text,
        'kota': kota.text,
        'nomor_plat': nomorPlat.text,
        'kapasitas': kapasitas.text,
        'price_km': double.tryParse(harga.text) ?? 0,
        'deskripsi': deskripsi.text,
        'gambar': fotoUrls,
      }).eq('id_jasa', int.parse(idJasa));

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui: $e')),
      );
    }
  }
}