import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easylive_app/controllers/halamanJasa/editKendaraan_controller.dart';
import 'package:easylive_app/widgets/pemilikJasa/home/editKendaraan.dart';
import 'package:easylive_app/core/color.dart';

class EditKendaraanView extends StatefulWidget {
  final String idJasa; // ← terima idJasa

  const EditKendaraanView({super.key, required this.idJasa});

  @override
  State<EditKendaraanView> createState() => _EditKendaraanViewState();
}

class _EditKendaraanViewState extends State<EditKendaraanView> {
  final controller = EditKendaraanController();
  List<File> newPhotos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.loadFromSupabase(widget.idJasa);
    setState(() => isLoading = false);
  }

  Future<void> _pickPhoto(int slotIndex) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() {
      final file = File(picked.path);
      // Slot 0,1,2 → existing photos; slot >= existingPhotos.length → new
      final existingCount = controller.existingPhotos.length;
      if (slotIndex < existingCount) {
        controller.existingPhotos[slotIndex] = ''; // kosongkan existing
        newPhotos.add(file);
      } else {
        newPhotos.add(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final existingPhotos = controller.existingPhotos;
    final totalPhotos = existingPhotos.length + newPhotos.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff2c3e50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Kendaraan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Perbarui informasi kendaraan Anda',
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// FOTO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Foto Kendaraan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$totalPhotos/3 Foto',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(3, (index) {
                          // Cek apakah slot ini punya foto
                          String? photoUrl;
                          File? photoFile;

                          if (index < existingPhotos.length &&
                              existingPhotos[index].isNotEmpty) {
                            photoUrl = existingPhotos[index];
                          } else {
                            final newIndex =
                                index - existingPhotos.where((e) => e.isNotEmpty).length;
                            if (newIndex >= 0 && newIndex < newPhotos.length) {
                              photoFile = newPhotos[newIndex];
                            }
                          }

                          final hasPhoto = photoUrl != null || photoFile != null;

                          return GestureDetector(
                            onTap: () => _pickPhoto(index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: const Color(0xfff0f0f0),
                                borderRadius: BorderRadius.circular(12),
                                border: hasPhoto
                                    ? Border.all(
                                        color: AppColors.yellow, width: 2)
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: hasPhoto
                                    ? (photoFile != null
                                        ? Image.file(photoFile,
                                            fit: BoxFit.cover)
                                        : Image.network(photoUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.camera_alt,
                                                    color: Colors.grey)))
                                    : const Icon(Icons.camera_alt,
                                        color: Colors.grey),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      /// INFORMASI DASAR
                      const Text(
                        'Informasi Dasar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      EditKendaraanWidget.inputField(
                          'Nama Kendaraan', controller.namaKendaraan),
                      const SizedBox(height: 12),
                      EditKendaraanWidget.inputField(
                          'Nomor Handphone', controller.nomorHp),
                      const SizedBox(height: 12),
                      StatefulBuilder(
                        builder: (context, setDropdownState) {
                          return EditKendaraanWidget.dropdownField(
                            'Tipe Kendaraan',
                            controller.tipeKendaraan,
                            (val) => setState(() {
                              controller.tipeKendaraan = val ?? '';
                            }),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      EditKendaraanWidget.inputField(
                        'Alamat Lengkap',
                        controller.alamat,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: EditKendaraanWidget.inputField(
                                'Kecamatan', controller.kecamatan),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: EditKendaraanWidget.inputField(
                                'Kota', controller.kota),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// DETAIL KENDARAAN
                      const Text(
                        'Detail Kendaraan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: EditKendaraanWidget.inputField(
                                'Nomor Plat', controller.nomorPlat),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: EditKendaraanWidget.inputField(
                                'Kapasitas/kg', controller.kapasitas),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: EditKendaraanWidget.inputField(
                                'Harga Sewa', controller.harga),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      EditKendaraanWidget.inputField(
                        'Deskripsi Kendaraan',
                        controller.deskripsi,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 30),

                      /// BUTTON
                      EditKendaraanWidget.buttonSimpan(() async {
                        await controller.simpanData(
                          context,
                          widget.idJasa,
                          newPhotos: newPhotos,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}