import 'package:flutter/material.dart';
import '../../../core/color.dart';

class DetailHeader extends StatelessWidget {
  final String imagePath;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final String heroTag;

  const DetailHeader({
    super.key,
    required this.imagePath,
    required this.onBack,
    required this.onFavorite,
    required this.isFavorite,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252,
      width: double.infinity,
      child: Stack(
        children: [
          Hero(
            tag: heroTag,
            child: Image.asset(
              imagePath,
              height: 252,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 22,
            top: 34,
            child: _buildBtn(Icons.arrow_back, onBack),
          ),
          Positioned(
            right: 32,
            top: 38,
            child: _buildBtn(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              onFavorite,
              color: AppColors.red,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PageDot(isActive: false),
                _PageDot(isActive: true),
                _PageDot(isActive: false),
              ],
            ),
          ),
        ],
      ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color ?? AppColors.primary, size: 20),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isActive ? 0.9 : 0.55),
        shape: BoxShape.circle,
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
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}
