import 'dart:io';

import 'package:flutter/material.dart';

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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Data has been successfully saved")));

    // Navigate back to dashboard after save
    Navigator.pop(context);
  }
}
