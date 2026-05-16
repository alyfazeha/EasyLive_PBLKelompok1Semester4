import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../user/profile/profile_menu_item.dart';

class PemilikJasaProfileMenuSection extends StatelessWidget {
  const PemilikJasaProfileMenuSection({super.key});

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

            ProfileMenuItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Kelola data dan pembayaran',
              onTap: () => Navigator.pushNamed(context, '/pemilik_jasa/dashboard'),
            ),
            const SizedBox(height: 12),

            ProfileMenuItem(
              icon: Icons.notifications,
              title: 'Notifikasi',
              subtitle: 'Info dan update terbaru',
              onTap: () => Navigator.pushNamed(context, '/pemilik_jasa/notifikasi'),
            ),
            const SizedBox(height: 12),

            ProfileMenuItem(
              icon: Icons.person,
              title: 'Profil',
              subtitle: 'Data pemilik jasa',
              onTap: () => Navigator.pushNamed(context, '/pemilik_jasa/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
