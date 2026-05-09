import 'package:flutter/material.dart';

class TambahKendaraanController {
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

  void simpanData(BuildContext context) {
    // Demo: print data and show success
    print("Nama Kendaraan: ${namaKendaraan.text}");
    print("Nomor HP: ${nomorHp.text}");
    print("Tipe Kendaraan: $tipeKendaraan");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Data berhasil disimpan")));

    // Navigate back to dashboard after save
    Navigator.pop(context);
  }
}