import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easylive_app/controllers/pemilikKos/editKamar_controller.dart';
import 'package:easylive_app/models/pemilikKos/editKamar_models.dart';
import 'package:easylive_app/widgets/pemilikKos/home/editKamar.dart';
import 'package:easylive_app/core/color.dart';

class EditKamarView extends StatefulWidget {
  final String idKost;

  EditKamarView({super.key, required this.idKost});

  @override
  State<EditKamarView> createState() => _EditKamarViewState();
}

class _EditKamarViewState extends State<EditKamarView> {
  final controller = EditKamarController();
  List<String> existingPhotos = []; // ← tambah ini
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final res = await Supabase.instance.client
          .from('kost')
          .select()
          .eq('id_kost', int.parse(widget.idKost))
          .single();

      final gambar = (res['gambar'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      
      final fasilitas = (res['fasilitas'] as List?) // ← pastikan ada di sini
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final kost = Kost(
        id: res['id_kost'].toString(),
        name: res['nama_kost'] ?? '',
        address: res['alamat'] ?? '',
        kecamatan: res['kecamatan'] ?? '', // ← dari kolom terpisah
        kota: res['kota'] ?? '',           // ← dari kolom terpisah
        tipeKost: res['tipe_kost'] ?? '',
        totalRoom: (res['jumlah_kamar'] as int?) ?? 0,
        availableRoom: (res['kamar_kosong'] as int?) ?? 0,
        price: res['harga'].toString(),
        description: res['deskripsi'] ?? '',
        images: gambar,
        facilities: fasilitas,
      );

      controller.loadKostData(kost);
      setState(() {
        existingPhotos = gambar; // ← tambah ini
        isLoading = false;
      });
      } catch (e) {
        setState(() => isLoading = false);
      }
  }

  @override
  Widget build(BuildContext context) {
    final fasilitasList = controller.getFasilitasList();

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                            "${existingPhotos.length}/3 Foto", // ← dinamis
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: List.generate(3, (index) {
                          final hasPhoto = index < existingPhotos.length;
                          final photoUrl = hasPhoto ? existingPhotos[index] : null;

                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Color(0xfff0f0f0),
                              borderRadius: BorderRadius.circular(12),
                              border: hasPhoto
                                  ? Border.all(color: AppColors.yellow, width: 2)
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: hasPhoto
                                  ? (photoUrl!.startsWith('http')
                                      ? Image.network(
                                          photoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Image.asset(photoUrl, fit: BoxFit.cover))
                                  : Icon(Icons.camera_alt, color: Colors.grey),
                            ),
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
                      EditKamarWidget.inputField(
                          "Nama Kost", controller.namaKost),
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
                                "Kecamatan", controller.kecamatan),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: EditKamarWidget.inputField(
                                "Kota", controller.kota),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      /// ================= DETAIL =================
                      Text(
                        "Detail Kost",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: EditKamarWidget.inputField(
                                "Jumlah Kamar", controller.jumlahKamar),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: EditKamarWidget.inputField(
                                "Kamar Kosong", controller.kamarKosong),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: EditKamarWidget.inputField(
                                "Harga Mulai", controller.harga),
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

                      /// ================= FASILITAS =================
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
                          final isSelected =
                              controller.selectedFasilitas.contains(index);
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
                      EditKamarWidget.buttonSimpan(() async {
                        await controller.simpanData(context, widget.idKost);
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}