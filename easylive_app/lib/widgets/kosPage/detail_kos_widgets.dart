import 'package:flutter/material.dart';
import '../../core/color.dart';

class DetailHeader extends StatelessWidget {
  final String imagePath;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final String heroTag; // Tambahkan heroTag agar sinkron dengan Card

  const DetailHeader({
    super.key, 
    required this.imagePath, 
    required this.onBack, 
    required this.onFavorite, 
    required this.isFavorite,
    required this.heroTag, // Pastikan ini dikirim dari View
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tambahkan Hero di sini
        Hero(
          tag: heroTag, 
          child: Image.asset(
            imagePath, 
            height: 350, 
            width: double.infinity, 
            fit: BoxFit.cover
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBtn(Icons.arrow_back, onBack),
                _buildBtn(
                  isFavorite ? Icons.favorite : Icons.favorite_border, 
                  onFavorite, 
                  color: isFavorite ? Colors.red : null
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.yellow, 
          borderRadius: BorderRadius.circular(12),
          // Tambahkan sedikit shadow agar tombol lebih 'pop out' di atas gambar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(icon, color: color ?? AppColors.primary),
      ),
    );
  }
}

class FacilityChip extends StatelessWidget {
  final String label;
  const FacilityChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin agar antar chip tidak menempel saat wrapping
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Text(
        label, 
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 12,
          color: AppColors.primary, // Gunakan primary color agar teks kontras
        )
      ),
    );
  }
}