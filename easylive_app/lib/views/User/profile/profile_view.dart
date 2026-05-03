import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/user/profile_controller.dart';
import '../../../widgets/user/profile/profile_header.dart';
import '../../../widgets/user/profile/profile_menu_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  ///LOGOUT + KONFIRMASI
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ProfileController.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Stack(
            children: [
              const ProfileHeader(),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: AppColors.background),
                    tooltip: "Logout",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 0),
          const Expanded(child: ProfileMenuSection()),
        ],
      ),
    );
  }
}
