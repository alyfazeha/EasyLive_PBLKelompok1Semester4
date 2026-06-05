import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../../../controllers/user/profile_controller.dart';

class PemilikJasaProfileHeader extends StatelessWidget {
  const PemilikJasaProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 38,
        20,
        22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.yellow, Color(0xFFFFD141)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellow.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white24,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            ProfileController.getUserName(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ProfileController.getUserEmail(),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

