import 'package:flutter/material.dart';
import '../../core/color.dart';

class CategorySection extends StatelessWidget {
  final VoidCallback onTapKost;
  final VoidCallback onTapJasa;

  const CategorySection({
    super.key,
    required this.onTapKost,
    required this.onTapJasa,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // kos
              Expanded(
                child: GestureDetector(
                  onTap: onTapKost,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAC793),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Kost",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E0006),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),

              // jasa
              Expanded(
                child: GestureDetector(
                  onTap: onTapJasa,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAC793),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Jasa",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E0006),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            " Recommendation",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5E0006),
            ),
          ),
        ],
      ),
    );
  }
}
