import 'package:flutter/material.dart';
import 'package:easylive_app/controllers/pemilikKos/editKamar_controller.dart';
import 'package:easylive_app/widgets/pemilikKos/home/editKamar.dart';
import 'package:easylive_app/core/color.dart';

class EditKamarView extends StatefulWidget {
  @override
  State<EditKamarView> createState() => _EditKamarViewState();
}

class _EditKamarViewState extends State<EditKamarView> {
  final controller = EditKamarController();

  @override
  void initState() {
    super.initState();
    // Load existing data for edit mode (demo data)
    _loadDemoData();
  }

  void _loadDemoData() {
    // In real app, this would be passed as parameter or fetched from service
    // For demo, we'll just use the existing dummy data
    controller.tipeKost = 'Putra';
  }

  @override
  Widget build(BuildContext context) {
    // Get fasilitas list
    final fasilitasList = controller.getFasilitasList();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,

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
              "Edit Kamar Kost",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Perbarui informasi kost Anda",
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
                      "1/3 Foto",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Photo slots
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(12),
                        border: index == 0
                            ? Border.all(color: AppColors.yellow, width: 2)
                            : null,
                      ),
                      child: index == 0
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/images/kos1.jpg",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(Icons.camera_alt, color: Colors.grey),
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

                EditKamarWidget.inputField("Nama Kost", controller.namaKost),

                SizedBox(height: 12),

                EditKamarWidget.dropdownField(
                  "Tipe Kost",
                  controller.tipeKost,
                  (val) => setState(() {
                    controller.tipeKost = val ?? '';
                  }),
                ),

                SizedBox(height: 12),

                EditKamarWidget.inputField(
                  "Alamat Lengkap",
                  controller.alamat,
                  maxLines: 2,
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: EditKamarWidget.inputField(
                        "Kecamatan",
                        controller.kecamatan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: EditKamarWidget.inputField(
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
                      child: EditKamarWidget.inputField(
                        "Jumlah Kamar",
                        controller.jumlahKamar,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: EditKamarWidget.inputField(
                        "Kamar Kosong",
                        controller.kamarKosong,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: EditKamarWidget.inputField(
                        "Harga Mulai",
                        controller.harga,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                EditKamarWidget.inputField(
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
                    final isSelected = controller.selectedFasilitas.contains(
                      index,
                    );
                    return EditKamarWidget.fasilitasItem(
                      item['icon'] as IconData,
                      item['label'] as String,
                      isSelected,
                      () {
                        setState(() {
                          controller.toggleFasilitas(index);
                        });
                      },
                    );
                  }),
                ),

                SizedBox(height: 30),

                /// ================= BUTTON =================
                EditKamarWidget.buttonSimpan(() {
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
