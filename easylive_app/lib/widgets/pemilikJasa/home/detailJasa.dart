import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikJasa/detail_jasa_model.dart';

class DetailJasaWidget extends StatelessWidget {
  final DetailJasa jasa;

  const DetailJasaWidget({super.key, required this.jasa});

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
                      itemCount: jasa.images.length,
                      itemBuilder: (_, i) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: AppColors.softBlue,
                            child: Image.asset(
                              jasa.images[i],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  jasa.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(jasa.address, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(
                      '${jasa.totalVehicle} kendaraan',
                      Icons.local_shipping_rounded,
                    ),
                    _buildChip(
                      '${jasa.availableVehicle} tersedia',
                      Icons.check_circle_outline_rounded,
                    ),
                    _buildChip(jasa.price, Icons.attach_money_rounded),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Detail Jasa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  jasa.description,
                  style: const TextStyle(color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Spesifikasi Kendaraan',
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
                  children: jasa.specifications
                      .map(_buildSpecificationChip)
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
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

  Widget _buildSpecificationChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: AppColors.darkBlue,
          ),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
