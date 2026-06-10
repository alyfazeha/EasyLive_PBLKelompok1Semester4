import 'package:flutter/material.dart';
import '../../../models/pemilikKos/detailKamar_models.dart';
import '../../../core/color.dart';

class DetailKostWidget extends StatelessWidget {
  final Kost kost;
  final List<Map<String, dynamic>> reviews;

  const DetailKostWidget({
    super.key,
    required this.kost,
    required this.reviews,
  });

  // ── helpers ────────────────────────────────────────────────────────────────

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
    final lower = text.toLowerCase();
    if (lower.contains('wifi')) {
      icon = Icons.wifi_rounded;
    } else if (lower.contains('ac') ||
        lower.contains('air conditioner') ||
        lower.contains('pendingin')) {
      icon = Icons.ac_unit_rounded;
    } else if (lower.contains('mandi') ||
        lower.contains('bath') ||
        lower.contains('kamar mandi')) {
      icon = Icons.bathroom_rounded;
    } else if (lower.contains('kasur') || lower.contains('bed')) {
      icon = Icons.bed_rounded;
    } else if (lower.contains('meja') || lower.contains('table')) {
      icon = Icons.table_restaurant_rounded;
    } else if (lower.contains('lemari') || lower.contains('closet')) {
      icon = Icons.door_sliding_rounded;
    } else if (lower.contains('parkir') || lower.contains('parking')) {
      icon = Icons.local_parking_rounded;
    } else if (lower.contains('dapur') || lower.contains('kitchen')) {
      icon = Icons.kitchen_rounded;
    } else if (lower.contains('laundry')) {
      icon = Icons.local_laundry_service_rounded;
    } else if (lower.contains('security')) {
      icon = Icons.security_rounded;
    } else {
      icon = Icons.check_circle_outline_rounded;
    }

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

  // ── rating helpers ─────────────────────────────────────────────────────────

  Widget _buildAverageRating() {
    final avg = reviews
            .map((r) => (r['rating'] as num?)?.toDouble() ?? 0)
            .reduce((a, b) => a + b) /
        reviews.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '${avg.toStringAsFixed(1)}  (${reviews.length} ulasan)',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRow(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star_rounded : Icons.star_border_rounded,
          size: 14,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final ulasan = review['ulasan'] as String? ?? '';
    final nama =
        (review['profiles'] as Map?)?['nama'] as String? ?? 'Pengguna';
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : 'U';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildStarRow(rating),
                  ],
                ),
              ),
            ],
          ),
          if (ulasan.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              ulasan,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyReview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border_rounded, size: 40, color: Colors.black26),
          SizedBox(height: 8),
          Text(
            'Belum ada ulasan',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              color: Colors.black38,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ulasan akan muncul setelah pesanan selesai',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: ListView(
              children: [
                // ── FOTO ────────────────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  child: SizedBox(
                    height: 180,
                    child: kost.images.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: Colors.black26,
                              ),
                            ),
                          )
                        : PageView.builder(
                            itemCount: kost.images.length,
                            itemBuilder: (_, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: kost.images[i].startsWith('http')
                                    ? Image.network(
                                        kost.images[i],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/kos1.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(kost.images[i],
                                        fit: BoxFit.cover),
                              );
                            },
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── NAMA ────────────────────────────────────────────────────
                Text(
                  kost.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(kost.address,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),

                // ── CHIPS INFO ───────────────────────────────────────────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip('${kost.totalRoom} kamar', Icons.bed_rounded),
                    _buildChip('${kost.availableRoom} kosong',
                        Icons.check_circle_outline_rounded),
                    _buildChip(kost.price, Icons.attach_money_rounded),
                    _buildChip(kost.tipeKost, Icons.people_rounded),
                  ],
                ),

                const SizedBox(height: 20),

                // ── DETAIL KOST ──────────────────────────────────────────────
                const Text(
                  'Detail Kost',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(kost.description,
                    style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 20),

                // ── FASILITAS ────────────────────────────────────────────────
                const Text(
                  'Fasilitas',
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
                  children:
                      kost.facilities.map((f) => _buildFacilityChip(f)).toList(),
                ),

                const SizedBox(height: 24),

                // ── RATING & ULASAN ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rating & Ulasan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    if (reviews.isNotEmpty) _buildAverageRating(),
                  ],
                ),
                const SizedBox(height: 12),

                reviews.isEmpty
                    ? _buildEmptyReview()
                    : Column(
                        children:
                            reviews.map((r) => _buildReviewCard(r)).toList(),
                      ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}