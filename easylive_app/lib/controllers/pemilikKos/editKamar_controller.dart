import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pemilikKos/editKamar_models.dart';

class EditKamarController {
  TextEditingController namaKost = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kota = TextEditingController();
  TextEditingController jumlahKamar = TextEditingController();
  TextEditingController kamarKosong = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  String tipeKost = '';
  List<int> selectedFasilitas = [];

  final supabase = Supabase.instance.client;

  // Ganti loadKostData — jangan split address, pakai field terpisah
  void loadKostData(Kost kost) {
    namaKost.text = kost.name;
    alamat.text = kost.address;       // kolom alamat
    kecamatan.text = kost.kecamatan;  // kolom kecamatan
    kota.text = kost.kota;            // kolom kota
    jumlahKamar.text = kost.totalRoom.toString();
    kamarKosong.text = kost.availableRoom.toString();
    harga.text = kost.price;
    deskripsi.text = kost.description;
    tipeKost = kost.tipeKost;

    final fasilitasList = getFasilitasList();
    selectedFasilitas = [];
    for (int i = 0; i < fasilitasList.length; i++) {
      if (kost.facilities.contains(fasilitasList[i]['label'])) {
        selectedFasilitas.add(i);
      }
    }
  }

  List<Map<String, dynamic>> getFasilitasList() {
    return [
      {'icon': Icons.wifi, 'label': 'Wifi'},
      {'icon': Icons.ac_unit, 'label': 'AC'},
      {'icon': Icons.bathtub, 'label': 'KM Dalam'},
      {'icon': Icons.local_parking, 'label': 'Parkir'},
      {'icon': Icons.kitchen, 'label': 'Dapur'},
      {'icon': Icons.local_laundry_service, 'label': 'Laundry'},
      {'icon': Icons.videocam, 'label': 'CCTV'},
      {'icon': Icons.water_drop, 'label': 'Dispenser'},
      {'icon': Icons.security, 'label': 'Keamanan 24 Jam'},
    ];
  }

  void toggleFasilitas(int index) {
    if (selectedFasilitas.contains(index)) {
      selectedFasilitas.remove(index);
    } else {
      selectedFasilitas.add(index);
    }
  }

  List<String> getSelectedFasilitas() {
    final fasilitasList = getFasilitasList();
    return selectedFasilitas
        .map((i) => fasilitasList[i]['label'] as String)
        .toList();
  }

    // Ganti getFullAddress — simpan alamat apa adanya
  String getFullAddress() {
    return alamat.text;
  }

  // Ganti simpanData — kirim kecamatan & kota terpisah
  Future<void> simpanData(BuildContext context, String idKost) async {
    try {
      await supabase.from('kost').update({
        'nama_kost': namaKost.text,
        'tipe_kost': tipeKost,
        'alamat': alamat.text,         // ← alamat saja
        'kecamatan': kecamatan.text,   // ← terpisah
        'kota': kota.text,             // ← terpisah
        'jumlah_kamar': int.tryParse(jumlahKamar.text) ?? 0,
        'kamar_kosong': int.tryParse(kamarKosong.text) ?? 0,
        'harga': double.tryParse(harga.text) ?? 0,
        'deskripsi': deskripsi.text,
        'fasilitas': getSelectedFasilitas(),
      }).eq('id_kost', int.parse(idKost));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data kost berhasil diperbarui")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui: $e")),
      );
    }
  }
}