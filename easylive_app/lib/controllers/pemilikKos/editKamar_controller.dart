import 'package:flutter/material.dart';
import '../../models/pemilikKos/editKamar_models.dart';

class EditKamarController {
  // Text controllers for form fields
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

  // Current kost data (for edit mode)
  Kost? _currentKost;

  // Load existing kost data
  void loadKostData(Kost kost) {
    _currentKost = kost;

    // Set text field values
    namaKost.text = kost.name;
    alamat.text = kost.address;
    jumlahKamar.text = kost.totalRoom.toString();
    kamarKosong.text = kost.availableRoom.toString();
    harga.text = kost.price;
    deskripsi.text = kost.description;
    tipeKost = kost.tipeKost;

    // Parse address (simple split)
    if (kost.address.contains(',')) {
      final parts = kost.address.split(',');
      if (parts.length >= 2) {
        kecamatan.text = parts[0].trim();
        kota.text = parts.sublist(1).join(',').trim();
      }
    } else {
      kecamatan.text = kost.address;
      kota.text = '';
    }

    // Set facilities selection based on existing facilities
    final fasilitasList = getFasilitasList();
    selectedFasilitas = [];
    for (int i = 0; i < fasilitasList.length; i++) {
      if (kost.facilities.contains(fasilitasList[i]['label'])) {
        selectedFasilitas.add(i);
      }
    }
  }

  // Get fasilitas list
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

  // Toggle fasilitas selection
  void toggleFasilitas(int index) {
    if (selectedFasilitas.contains(index)) {
      selectedFasilitas.remove(index);
    } else {
      selectedFasilitas.add(index);
    }
  }

  // Get selected fasilitas list
  List<String> getSelectedFasilitas() {
    final fasilitasList = getFasilitasList();
    return selectedFasilitas
        .map((i) => fasilitasList[i]['label'] as String)
        .toList();
  }

  // Get full address
  String getFullAddress() {
    if (kecamatan.text.isNotEmpty && kota.text.isNotEmpty) {
      return '${kecamatan.text}, ${kota.text}';
    } else if (kecamatan.text.isNotEmpty) {
      return kecamatan.text;
    }
    return alamat.text;
  }

  // Update kost data (simulated)
  void simpanData(BuildContext context) {
    // Print data for demo
    print("Nama Kost: ${namaKost.text}");
    print("Tipe Kost: $tipeKost");
    print("Alamat: ${getFullAddress()}");
    print("Jumlah Kamar: ${jumlahKamar.text}");
    print("Kamar Kosong: ${kamarKosong.text}");
    print("Harga: ${harga.text}");
    print("Deskripsi: ${deskripsi.text}");
    print("Fasilitas: ${getSelectedFasilitas()}");

    // Show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Data kost berhasil diperbarui")));

    // Navigate back
    Navigator.pop(context);
  }
}
