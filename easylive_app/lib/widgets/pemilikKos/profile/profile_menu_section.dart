import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/profile_controller.dart';
import '../../../widgets/pemilikKos/profile/profile_menu_item.dart';

class PemilikKosProfileMenuSection extends StatelessWidget {
  final PemilikKosProfileController controller;

  const PemilikKosProfileMenuSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellow.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellow.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 15),
            PemilikKosProfileMenuItem(
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Ubah informasi profil Anda',
              onTap: () =>
                  Navigator.pushNamed(context, '/pemilik_kos/edit_profile'),
            ),
            const SizedBox(height: 12),
            // ← Favorit dihapus
            PemilikKosProfileMenuItem(
              icon: Icons.security,
              title: 'Keamanan',
              subtitle: 'Password dan keamanan akun',
              onTap: () =>
                  Navigator.pushNamed(context, '/pemilik_kos/security'),
            ),
          ],
        ),
      ),
    );
  }
}