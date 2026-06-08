import 'package:flutter/material.dart';
import '../../../models/pemilikJasa/detail_jasa_model.dart';
import '../../../core/color.dart';

class DetailJasaWidget extends StatelessWidget {
  final DetailJasa jasa;

  const DetailJasaWidget({super.key, required this.jasa});

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
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.yellow.withOpacity(0.15),
        border: Border.all(color: AppColors.yellow),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.darkBlue),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

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
                    // FOTO
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        height: 300,
                        child: jasa.images.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 48,
                                        color: Colors.black26,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Foto belum tersedia',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : PageView.builder(
                                itemCount: jasa.images.length,
                                itemBuilder: (_, i) {
                                  final path = jasa.images[i];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: path.startsWith('http')
                                        ? Image.network(
                                            path,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                              color: Colors.grey.shade100,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 48,
                                                  color: Colors.black26,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Image.asset(path, fit: BoxFit.cover),
                                  );
                                },
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // NAMA
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

                    // ALAMAT
                    Text(
                      jasa.address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),

                    // CHIPS INFO
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(jasa.price, Icons.attach_money_rounded),
                        _buildChip(jasa.tipeMobil, Icons.directions_car_rounded),
                        _buildChip(jasa.kapasitas, Icons.inventory_2_outlined),
                        _buildChip(jasa.nomorPlat, Icons.confirmation_number_outlined),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // DETAIL JASA
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

                    // INFORMASI KENDARAAN
                    const Text(
                      'Informasi Kendaraan',
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
                      children: [
                        _buildFacilityChip(jasa.tipeMobil, Icons.directions_car_rounded),
                        _buildFacilityChip(jasa.kapasitas, Icons.inventory_2_outlined),
                        _buildFacilityChip(jasa.nomorPlat, Icons.confirmation_number_outlined),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // INFO KONTAK
                    const Text(
                      'Informasi Kontak',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkBlue,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.phone_outlined, 'Nomor HP', jasa.nomorHp),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on_outlined, 'Kecamatan', jasa.kecamatan),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_city_outlined, 'Kota', jasa.kota),
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