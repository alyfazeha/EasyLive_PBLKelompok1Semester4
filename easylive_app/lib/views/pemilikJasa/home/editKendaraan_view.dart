import 'package:flutter/material.dart';
import 'package:easylive_app/controllers/halamanJasa/editKendaraan_controller.dart';
import 'package:easylive_app/widgets/pemilikJasa/home/editKendaraan.dart';
import 'package:easylive_app/models/pemilikJasa/detail_jasa_model.dart';

class EditKendaraanView extends StatefulWidget {
  final DetailJasa jasa;

  const EditKendaraanView({super.key, required this.jasa});

  @override
  State<EditKendaraanView> createState() => _EditKendaraanViewState();
}

class _EditKendaraanViewState extends State<EditKendaraanView> {
  final controller = EditKendaraanController();

  @override
  void initState() {
    super.initState();
    // Load existing data from DetailJasa
    controller.loadKendaraanDataFromJasa(widget.jasa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Color(0xff2c3e50),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Kendaraan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Perbarui informasi kendaraan Anda",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= FOTO =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Foto Kendaraan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1/3 Foto",
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

                EditKendaraanWidget.inputField(
                  "Nama Kendaraan",
                  controller.namaKendaraan,
                ),

                SizedBox(height: 12),

                EditKendaraanWidget.inputField(
                  "Nomor Handphone",
                  controller.nomorHp,
                ),

                SizedBox(height: 12),

                EditKendaraanWidget.dropdownField(
                  "Tipe Kendaraan",
                  controller.tipeKendaraan,
                  (val) => setState(() {
                    controller.tipeKendaraan = val ?? '';
                  }),
                ),

                SizedBox(height: 12),

                EditKendaraanWidget.inputField(
                  "Alamat Lengkap",
                  controller.alamat,
                  maxLines: 2,
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: EditKendaraanWidget.inputField(
                        "Kecamatan",
                        controller.kecamatan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: EditKendaraanWidget.inputField(
                        "Kota",
                        controller.kota,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                /// ================= DETAIL =================
                Text(
                  "Detail Kendaraan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                // Row: Nomor Plat | Kapasitas | Harga
                Row(
                  children: [
                    Expanded(
                      child: EditKendaraanWidget.inputField(
                        "Nomor Plat",
                        controller.nomorPlat,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: EditKendaraanWidget.inputField(
                        "Kapasitas",
                        controller.kapasitas,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: EditKendaraanWidget.inputField(
                        "Harga Sewa",
                        controller.harga,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                EditKendaraanWidget.inputField(
                  "Deskripsi Kendaraan",
                  controller.deskripsi,
                  maxLines: 3,
                ),

                SizedBox(height: 30),

                /// ================= BUTTON =================
                EditKendaraanWidget.buttonSimpan(() {
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
