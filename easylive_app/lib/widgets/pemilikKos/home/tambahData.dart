import 'package:easylive_app/core/color.dart';
import 'package:flutter/material.dart';

class TambahDataWidget {
  /* ===============================
     BACK BUTTON (KOTAK KUNING)
  =============================== */
  static Widget backButton(VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.darkBlue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: "Masukkan ${label.toLowerCase()}",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xff2c3e50)),
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
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        SizedBox(height: 5),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Text(
                "Pilih ${label.toLowerCase()}",
                style: TextStyle(fontSize: 12),
              ),
              isExpanded: true,
              style: TextStyle(fontSize: 12, color: Colors.black87),
              items: ["Putra", "Putri", "Campur"].map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 12)),
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
     FASILITAS ITEM (SELECTABLE)
  =============================== */
  static Widget fasilitasItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Color(0xfff0f0f0),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.darkBlue, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.darkBlue : Colors.grey[700],
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.darkBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ===============================
     DEFAULT FASILITAS LIST
  =============================== */
  static List<Map<String, dynamic>> getFasilitasList() {
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

  /* ===============================
     BUTTON SIMPAN (KUNING, TULISAN BIRU)
  =============================== */
  static Widget buttonSimpan(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Simpan Data Kost",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}
