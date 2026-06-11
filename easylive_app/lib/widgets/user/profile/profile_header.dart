import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/user/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final photoUrl = ProfileController.getUserImage();
    final hasPhoto = ProfileController.hasPhoto();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
        ),
        borderRadius: BorderRadius.zero,
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
          // ── Tombol Back ─────────────────────────────────────────────────
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

          // ── Avatar dengan ring kuning ────────────────────────────────────
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
              // Tampilkan foto dari Supabase jika tersedia
              backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
              onBackgroundImageError: hasPhoto ? (_, __) {} : null,
              // Fallback ke icon jika tidak ada foto
              child: !hasPhoto
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(height: 15),

          // ── Nama ─────────────────────────────────────────────────────────
          Text(
            ProfileController.getUserName(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // ── Email ─────────────────────────────────────────────────────────
          Text(
            ProfileController.getUserEmail(),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}