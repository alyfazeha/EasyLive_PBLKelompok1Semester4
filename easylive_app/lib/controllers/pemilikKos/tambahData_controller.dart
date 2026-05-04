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

  void simpanData(BuildContext context) {
    // Demo: print data and show success
    print("Nama Kost: ${namaKost.text}");
    print("Nomor HP: ${nomorHp.text}");
    print("Tipe Kost: $tipeKost");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Data berhasil disimpan")));

    // Navigate back to dashboard after save
    Navigator.pop(context);
  }
}
