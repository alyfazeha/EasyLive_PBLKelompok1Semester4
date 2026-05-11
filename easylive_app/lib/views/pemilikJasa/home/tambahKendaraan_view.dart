import 'package:flutter/material.dart';
import 'package:easylive_app/controllers/halamanJasa/tambahKendaraan_controller.dart';
import 'package:easylive_app/widgets/pemilikJasa/home/tambahKendaraan.dart';

import 'package:easylive_app/core/color.dart';


class TambahKendaraanView extends StatefulWidget {
  const TambahKendaraanView({super.key});

  @override
  State<TambahKendaraanView> createState() => _TambahKendaraanViewState();
}

class _TambahKendaraanViewState extends State<TambahKendaraanView> {
  final controller = TambahKendaraanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Color(0xff2c3e50),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah Kendaraan Baru",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Lengkapi informasi kendaraan Anda",
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
                      "0/3 Foto",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: List.generate(3, (index) {
                    return TambahKendaraanWidget.fotoSlot(
                      index: index,
                      controller: controller,
                      context: context,
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

                TambahKendaraanWidget.inputField(
                  "Nama Kendaraan",
                  controller.namaKendaraan,
                ),

                SizedBox(height: 12),

                TambahKendaraanWidget.inputField(
                  "Nomor Handphone",
                  controller.nomorHp,
                ),

                SizedBox(height: 12),

                TambahKendaraanWidget.dropdownField(
                  "Tipe Kendaraan",
                  controller.tipeKendaraan,
                  (val) => setState(() {
                    controller.tipeKendaraan = val ?? '';
                  }),
                ),

                SizedBox(height: 12),

                TambahKendaraanWidget.inputField(
                  "Alamat Lengkap",
                  controller.alamat,
                  maxLines: 2,
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TambahKendaraanWidget.inputField(
                        "Kecamatan",
                        controller.kecamatan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TambahKendaraanWidget.inputField(
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
                      child: TambahKendaraanWidget.inputField(
                        "Nomor Plat",
                        controller.nomorPlat,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahKendaraanWidget.inputField(
                        "Kapasitas",
                        controller.kapasitas,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahKendaraanWidget.inputField(
                        "Harga Sewa",
                        controller.harga,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                TambahKendaraanWidget.inputField(
                  "Deskripsi Kendaraan",
                  controller.deskripsi,
                  maxLines: 3,
                ),

                SizedBox(height: 30),

                /// ================= BUTTON =================
                TambahKendaraanWidget.buttonSimpan(() {
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
