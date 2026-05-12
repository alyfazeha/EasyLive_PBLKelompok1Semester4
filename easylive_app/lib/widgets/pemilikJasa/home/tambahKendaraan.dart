import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/color.dart';
import '../../../controllers/halamanJasa/tambahKendaraan_controller.dart';

class TambahKendaraanWidget {
  /* ===============================
     INPUT FIELD (TEKS LEBIH KECIL)
  =============================== */
  static Widget inputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Masukkan ${label.toLowerCase()}',
            hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff2c3e50)),
            ),
          ),
        ),
      ],
    );
  }

  /* ===============================
     DROPDOWN FIELD (TEKS LEBIH KECIL)
  =============================== */
  static Widget dropdownField(
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Text(
                'Pilih ${label.toLowerCase()}',
                style: const TextStyle(fontSize: 12),
              ),
              isExpanded: true,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              items: ['Mobil', 'Motor', 'Truk'].map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  /* ===============================
     BUTTON SIMPAN
  =============================== */
  static Widget buttonSimpan(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.darkBlue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /* ===============================
     FOTO PICKER 0/3
  =============================== */
  static Widget fotoSlot({
    required int index,
    required TambahKendaraanController controller,
    required BuildContext context,
  }) {
    final hasPhoto = index < controller.selectedPhotosBytes.length &&
        index < controller.selectedPhotos.length &&
        controller.selectedPhotosBytes.length > index &&
        controller.selectedPhotosBytes[index].isNotEmpty;

    return InkWell(
      onTap: () async {
        final picker = ImagePicker();

        // sederhanakan: pilih dari gallery
        final XFile? picked = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
        );
        if (picked == null) return;

        final bytes = await picked.readAsBytes();
        final file = File(picked.path);

        controller.setFoto(
          slotIndex: index,
          bytes: bytes,
          file: file,
        );

        if (context.mounted) {
          // minta rebuild parent
          Navigator.of(context).pop();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xfff0f0f0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasPhoto
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.memory(
                        controller.selectedPhotosBytes[index],
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
            : const Icon(Icons.camera_alt, color: Colors.grey),
      ),
    );
  }
}

