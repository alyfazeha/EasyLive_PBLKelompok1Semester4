import 'package:flutter/material.dart';
import 'package:easylive_app/controllers/pemilikKos/tambahData_controller.dart';
import 'package:easylive_app/widgets/pemilikKos/home/tambahData.dart';
import 'package:easylive_app/core/color.dart';

class TambahDataView extends StatefulWidget {
  @override
  State<TambahDataView> createState() => _TambahDataViewState();
}

class _TambahDataViewState extends State<TambahDataView> {
  final controller = TambahDataController();

  // List of selected fasilitas (index)
  final List<int> selectedFasilitas = [];

  void _toggleFasilitas(int index) {
    setState(() {
      if (selectedFasilitas.contains(index)) {
        selectedFasilitas.remove(index);
      } else {
        selectedFasilitas.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get fasilitas list
    final fasilitasList = TambahDataWidget.getFasilitasList();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,

      appBar: AppBar(
        backgroundColor: Color(0xff2c3e50),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah Kost Baru",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Lengkapi informasi kost Anda",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= FOTO =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Foto Kost",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "0/3 Foto",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.grey),
                    );
                  }),
                ),

                SizedBox(height: 20),

                /// ================= INFORMASI DASAR =================
                Text(
                  "Informasi Dasar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField("Nama Kost", controller.namaKost),

                SizedBox(height: 12),

                TambahDataWidget.dropdownField(
                  "Tipe Kost",
                  controller.tipeKost,
                  (val) => setState(() {
                    controller.tipeKost = val ?? '';
                  }),
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField(
                  "Alamat Lengkap",
                  controller.alamat,
                  maxLines: 2,
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Kecamatan",
                        controller.kecamatan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Kota",
                        controller.kota,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                /// ================= DETAIL (3 KOLOM) =================
                Text(
                  "Detail Kost",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                // Row: Jumlah Kamar | Kamar Kosong | Harga Mulai
                Row(
                  children: [
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Jumlah Kamar",
                        controller.jumlahKamar,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Kamar Kosong",
                        controller.kamarKosong,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Harga Mulai",
                        controller.harga,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField(
                  "Deskripsi Kost",
                  controller.deskripsi,
                  maxLines: 3,
                ),

                SizedBox(height: 20),

                /// ================= FASILITAS (SELECTABLE) =================
                Text(
                  "Fasilitas",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(fasilitasList.length, (index) {
                    final item = fasilitasList[index];
                    final isSelected = selectedFasilitas.contains(index);
                    return TambahDataWidget.fasilitasItem(
                      item['icon'] as IconData,
                      item['label'] as String,
                      isSelected,
                      () => _toggleFasilitas(index),
                    );
                  }),
                ),

                SizedBox(height: 30),

                /// ================= BUTTON =================
                TambahDataWidget.buttonSimpan(() {
                  controller.simpanData(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
