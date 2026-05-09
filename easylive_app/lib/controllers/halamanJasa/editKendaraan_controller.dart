import 'package:flutter/material.dart';
import '../../models/halamanJasa/kendaraan_model.dart';
import '../../models/pemilikJasa/detail_jasa_model.dart';

class EditKendaraanController {
  // Text controllers for form fields
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

  // Load existing kendaraan data from DetailJasa
  void loadKendaraanDataFromJasa(DetailJasa jasa) {
    // Set text field values from DetailJasa
    namaKendaraan.text = jasa.name;
    nomorHp.text = ''; // Not in DetailJasa
    alamat.text = jasa.address;
    kapasitas.text = jasa.totalVehicle.toString();
    harga.text = jasa.price;
    deskripsi.text = jasa.description;

    // Determine tipe kendaraan from name
    tipeKendaraan = _determineTipeKendaraan(jasa.name);

    // Parse address to get kecamatan and kota
    if (jasa.address.contains(',')) {
      final parts = jasa.address.split(',');
      if (parts.length >= 2) {
        kecamatan.text = parts[0].trim();
        kota.text = parts.sublist(1).join(',').trim();
      }
    } else {
      kecamatan.text = jasa.address;
      kota.text = '';
    }
  }

  // Load existing kendaraan data from KendaraanModel
  void loadKendaraanData(KendaraanModel kendaraan) {
    // Set text field values
    namaKendaraan.text = kendaraan.namaKendaraan;
    nomorHp.text = kendaraan.nomorHp;
    alamat.text = kendaraan.alamat;
    kecamatan.text = kendaraan.kecamatan;
    kota.text = kendaraan.kota;
    nomorPlat.text = kendaraan.nomorPlat;
    kapasitas.text = kendaraan.kapasitas;
    harga.text = kendaraan.harga;
    deskripsi.text = kendaraan.deskripsi;
    tipeKendaraan = kendaraan.tipeKendaraan;
  }

  // Helper to determine tipe kendaraan from name
  String _determineTipeKendaraan(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('truck')) return 'Truk';
    if (lower.contains('motor')) return 'Motor';
    if (lower.contains('pickup')) return 'Mobil';
    return '';
  }

  void simpanData(BuildContext context) {
    // Demo: print data and show success
    print("Nama Kendaraan: ${namaKendaraan.text}");
    print("Nomor Plat: ${nomorPlat.text}");
    print("Tipe Kendaraan: $tipeKendaraan");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Data berhasil diperbarui")));

    // Navigate back to dashboard after save
    Navigator.pop(context);
  }
}
