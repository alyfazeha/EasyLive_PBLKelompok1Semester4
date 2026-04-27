import 'package:flutter/material.dart';
import '../../widgets/profile/profile_menu_item.dart';
import '../../controllers/profile_controller.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const Text(
            "Menu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          ProfileMenuItem(
            icon: Icons.person,
            title: "Edit Profile",
            subtitle: "Ubah informasi profil Anda",
            onTap: () => Navigator.pushNamed(context, '/edit_profile'),
          ),

          ProfileMenuItem(
            icon: Icons.favorite,
            title: "Favorit",
            subtitle: "Kos yang Anda simpan",
            onTap: () => Navigator.pushNamed(context, '/favorite'),
          ),

          ProfileMenuItem(
            icon: Icons.security,
            title: "Keamanan",
            subtitle: "Password dan keamanan akun",
            onTap: () => Navigator.pushNamed(context, '/security'),
          ),
        ],
      ),
    );
  }
}
