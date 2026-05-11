import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../../../controllers/user/profile_controller.dart';
import '../../../../widgets/pemilikJasa/profile/profile_header.dart';
import '../../../../widgets/user/profile/profile_menu_section.dart';

class PemilikJasaProfileView extends StatelessWidget {
  const PemilikJasaProfileView({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E4A7A),
              Color(0xFF1E4A7A),
            ],
          ),
        ),
        child: Column(
          children: [
            // Back button (kiri atas) - tanpa Positioned agar tidak error layout
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.background,
                ),
                tooltip: 'Back',
                padding: const EdgeInsets.all(0),
              ),
            ),
            Stack(
              children: [
                const PemilikJasaProfileHeader(),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.yellow.withOpacity(0.35),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: IconButton(
                        onPressed: () => _logout(context),
                        icon: const Icon(
                          Icons.logout,
                          color: AppColors.background,
                        ),
                        tooltip: 'Logout',
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBlue.withOpacity(0.12),
                      blurRadius: 22,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: const ProfileMenuSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

