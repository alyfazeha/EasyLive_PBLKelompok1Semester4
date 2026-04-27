import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../controllers/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(ProfileController.getUserImage()),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.camera_alt, size: 18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            ProfileController.getUserName(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            ProfileController.getUserEmail(),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
