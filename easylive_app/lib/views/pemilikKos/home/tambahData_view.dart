import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easylive_app/controllers/pemilikKos/tambahData_controller.dart';
import 'package:easylive_app/widgets/pemilikKos/home/tambahData.dart';
import 'package:easylive_app/core/color.dart';

class TambahDataView extends StatefulWidget {
  @override
  State<TambahDataView> createState() => _TambahDataViewState();
}

class _TambahDataViewState extends State<TambahDataView> {
  final controller = TambahDataController();

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

  Future<void> _pickPhoto({
    required int slotIndex,
    required ImageSource source,
  }) async {
    // REQUEST PERMISSION
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    }

    if (source == ImageSource.gallery) {
      await Permission.photos.request();
    }

    final picker = ImagePicker();

    final XFile? picked = await picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );

    if (picked == null) return;

    final Uint8List bytes = await picked.readAsBytes();

    setState(() {
      // Maintain bytes list size up to slotIndex
      while (controller.selectedPhotosBytes.length < slotIndex) {
        controller.selectedPhotosBytes.add(Uint8List(0));
      }

      if (controller.selectedPhotosBytes.length == slotIndex) {
        controller.selectedPhotosBytes.add(bytes);
      } else {
        controller.selectedPhotosBytes[slotIndex] = bytes;
      }

      controller.selectedPhotosBytes.removeWhere((b) => b.isEmpty);

      if (controller.selectedPhotosBytes.length > 3) {
        controller.selectedPhotosBytes.removeRange(
          3,
          controller.selectedPhotosBytes.length,
        );
      }

      while (controller.selectedPhotos.length < slotIndex) {
        controller.selectedPhotos.add(File(''));
      }
      final file = File(picked.path);
      if (controller.selectedPhotos.length == slotIndex) {
        controller.selectedPhotos.add(file);
      } else {
        controller.selectedPhotos[slotIndex] = file;
      }
      controller.selectedPhotos.removeWhere((f) => f.path.isEmpty);
      if (controller.selectedPhotos.length > 3) {
        controller.selectedPhotos.removeRange(
          3,
          controller.selectedPhotos.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get fasilitas list
    final fasilitasList = TambahDataWidget.getFasilitasList();

    final photoCount = controller.selectedPhotosBytes.length;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Color(0xff2c3e50),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Kost",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Complete your kost information",
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
                      "Kost Photos",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$photoCount/3 Photos",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: List.generate(3, (index) {
                    final hasPhoto =
                        index < controller.selectedPhotosBytes.length;
                    final file = hasPhoto
                        ? controller.selectedPhotos[index]
                        : null;

                    return InkWell(
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Choose Photo",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        /// CAMERA
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);

                                            await _pickPhoto(
                                              slotIndex: index,
                                              source: kIsWeb
                                                  ? ImageSource.gallery
                                                  : ImageSource.camera,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(18),
                                                decoration: BoxDecoration(
                                                  color: AppColors.yellow
                                                      .withOpacity(0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: AppColors.yellow,
                                                  size: 30,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Camera"),
                                            ],
                                          ),
                                        ),

                                        /// GALLERY
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);

                                            await _pickPhoto(
                                              slotIndex: index,
                                              source: ImageSource.gallery,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(18),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.photo,
                                                  color: Colors.blue,
                                                  size: 30,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Gallery"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },

                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Color(0xfff0f0f0),
                          borderRadius: BorderRadius.circular(12),
                          border: index < photoCount
                              ? Border.all(color: AppColors.yellow, width: 2)
                              : null,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xfff0f0f0),
                              ),
                              child: hasPhoto
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: kIsWeb
                                          ? Image.memory(
                                              controller
                                                  .selectedPhotosBytes[index],
                                              fit: BoxFit.cover,
                                              width: 65,
                                              height: 65,
                                            )
                                          : Image.file(
                                              controller.selectedPhotos[index],
                                              fit: BoxFit.cover,
                                              width: 65,
                                              height: 65,
                                            ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                            ),

                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 20),

                /// ================= INFORMASI DASAR =================
                Text(
                  "Basic Information",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField("Kost Name", controller.namaKost),

                SizedBox(height: 12),

                TambahDataWidget.inputField("Phone Number", controller.nomorHp),

                SizedBox(height: 12),

                TambahDataWidget.dropdownField(
                  "Kost Type",
                  controller.tipeKost,
                  (val) => setState(() {
                    controller.tipeKost = val ?? '';
                  }),
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField(
                  "Complete Address",
                  controller.alamat,
                  maxLines: 2,
                ),

                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "District",
                        controller.kecamatan,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "City",
                        controller.kota,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Text(
                  "Kost Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                // Row: Jumlah Kamar | Kamar Kosong | Harga Mulai
                Row(
                  children: [
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Number of Rooms",
                        controller.jumlahKamar,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Empty Rooms",
                        controller.kamarKosong,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TambahDataWidget.inputField(
                        "Starting Price",
                        controller.harga,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                TambahDataWidget.inputField(
                  "Kost Description",
                  controller.deskripsi,
                  maxLines: 3,
                ),

                SizedBox(height: 20),

                /// ================= FASILITAS (SELECTABLE) =================
                Text(
                  "Facilities",
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
                TambahDataWidget.buttonSimpan(() async {
                  // Ambil label fasilitas yang dipilih
                  final fasilitasLabels = selectedFasilitas
                      .map((i) => fasilitasList[i]['label'] as String)
                      .toList();

                  await controller.simpanData(context, fasilitasLabels); // ← kirim fasilitasLabels
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
