import 'package:flutter/material.dart';
import '../../models/kos_model.dart';
import '../../core/color.dart';

class KostCard extends StatelessWidget {
  final KostModel kost;

  const KostCard({super.key, required this.kost});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardPrimaryBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                kost.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          /// TEXT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kost.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  kost.loc ?? kost.address,
                  style: const TextStyle(color: Colors.white70),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Rp ${kost.price ?? 0}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}