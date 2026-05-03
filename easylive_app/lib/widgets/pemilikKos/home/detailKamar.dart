import 'package:flutter/material.dart';
import '../../../models/pemilikKos/detailKamar_models.dart';
import '../../../core/color.dart';
import '../../../views/pemilikKos/home/editKamar_view.dart';

class DetailKostWidget extends StatelessWidget {
  final Kost kost;

  const DetailKostWidget({required this.kost});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 180,
                    child: PageView.builder(
                      itemCount: kost.images.length,
                      itemBuilder: (_, i) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(kost.images[i], fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  kost.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(kost.address, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip("${kost.totalRoom} kamar", Icons.bed_rounded),
                    _buildChip(
                      "${kost.availableRoom} kosong",
                      Icons.check_circle_outline_rounded,
                    ),
                    _buildChip(kost.price, Icons.attach_money_rounded),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Detail Kost",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kost.description,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Fasilitas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: kost.facilities.map((f) {
                    return _buildFacilityChip(f);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
foregroundColor: AppColors.yellow,
                    side: const BorderSide(color: AppColors.yellow),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Kelola Kamar"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.darkBlue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditKamarView()),
                    );
                  },
                  child: const Text("Edit Kost"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.darkBlue),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String text) {
    IconData icon;
    if (text.toLowerCase().contains('wifi')) {
      icon = Icons.wifi_rounded;
    } else if (text.toLowerCase().contains('ac') ||
        text.toLowerCase().contains('air conditioner') ||
        text.toLowerCase().contains('pendingin')) {
      icon = Icons.ac_unit_rounded;
    } else if (text.toLowerCase().contains('mandi') ||
        text.toLowerCase().contains('bath') ||
        text.toLowerCase().contains('kamar mandi')) {
      icon = Icons.bathroom_rounded;
    } else if (text.toLowerCase().contains('kasur') ||
        text.toLowerCase().contains('bed')) {
      icon = Icons.bed_rounded;
    } else if (text.toLowerCase().contains('meja') ||
        text.toLowerCase().contains('table')) {
      icon = Icons.table_restaurant_rounded;
    } else if (text.toLowerCase().contains('lemari') ||
        text.toLowerCase().contains('closet')) {
      icon = Icons.door_sliding_rounded;
    } else if (text.toLowerCase().contains('parkir') ||
        text.toLowerCase().contains('parking')) {
      icon = Icons.local_parking_rounded;
    } else if (text.toLowerCase().contains('dapur') ||
        text.toLowerCase().contains('kitchen')) {
      icon = Icons.kitchen_rounded;
    } else if (text.toLowerCase().contains('laundry')) {
      icon = Icons.local_laundry_service_rounded;
    } else if (text.toLowerCase().contains('security')) {
      icon = Icons.security_rounded;
    } else {
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.darkBlue),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
