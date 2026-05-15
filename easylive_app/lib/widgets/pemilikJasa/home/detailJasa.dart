import 'package:flutter/material.dart';

import '../../../models/pemilikJasa/detail_jasa_model.dart';
import '../../../core/color.dart';

class DetailJasaWidget extends StatelessWidget {
  final DetailJasa jasa;

  const DetailJasaWidget({super.key, required this.jasa});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE (ambil dari pemilikJasa jika tersedia; jika tidak, fallback asset)
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: (jasa.images.isEmpty
                              ? 1
                              : jasa.images.length),
                          itemBuilder: (_, i) {
                            final path = jasa.images.isEmpty
                                ? 'assets/images/pickup-removed.png'
                                : jasa.images[i];

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: path.startsWith('http')
                                  ? Image.network(
                                      path,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Image.asset(
                                            'assets/images/pickup-removed.png',
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                  : Image.asset(path, fit: BoxFit.cover),
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
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jasa.address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(jasa.price, Icons.attach_money_rounded),
                        _buildChip(
                          jasa.totalVehicle.toString(),
                          Icons.directions_car_rounded,
                        ),
                        _buildChip(
                          jasa.specifications.join(', '),
                          Icons.build_circle_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Detail Jasa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkBlue,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jasa.description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Spesifikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkBlue,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: jasa.specifications.isEmpty
                          ? [
                              _buildFacilityChip(
                                '-',
                                Icons.check_circle_outline_rounded,
                              ),
                            ]
                          : jasa.specifications
                                .map(
                                  (s) => _buildFacilityChip(
                                    s,
                                    Icons.check_circle_outline_rounded,
                                  ),
                                )
                                .toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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

Widget _buildFacilityChip(String text, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.yellow,
      border: Border.all(color: AppColors.darkBlue),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.darkBlue),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
