import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/profile_controller.dart';

class PemilikKosProfileHeader extends StatelessWidget {
  final PemilikKosProfileController controller;

  const PemilikKosProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = controller.userImage.isNotEmpty &&
        controller.userImage.startsWith('http');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 22),
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
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
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
              // ← foto dari Supabase jika ada, fallback ke asset
              backgroundImage: hasPhoto
                  ? NetworkImage(controller.userImage)
                  : const AssetImage('assets/images/logo-easylive.png')
                      as ImageProvider,
              onBackgroundImageError: hasPhoto
                  ? (_, __) {} // silent error, fallback otomatis
                  : null,
              child: !hasPhoto ? null : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            controller.userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.userEmail,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}