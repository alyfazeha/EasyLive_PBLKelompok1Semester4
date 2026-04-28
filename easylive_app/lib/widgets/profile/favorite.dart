import 'package:flutter/material.dart';
import '../../models/kos_model.dart';
import '../../core/color.dart';

/// 🔥 CARD FAVORIT
class FavoriteCard extends StatelessWidget {
  final KostModel kost;
  final VoidCallback onTap;

  const FavoriteCard({super.key, required this.kost, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                kost.image,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kost.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    kost.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    kost.price != null ? "Rp ${kost.price}" : "-",
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 EMPTY STATE
class FavoriteEmpty extends StatelessWidget {
  const FavoriteEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Belum ada kos favorit ❤️",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
