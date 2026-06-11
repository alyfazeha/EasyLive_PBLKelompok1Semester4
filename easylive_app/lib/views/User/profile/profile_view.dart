import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/user/profile_controller.dart';
import '../../../widgets/user/profile/profile_header.dart';
import '../../../widgets/user/profile/profile_menu_section.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await ProfileController.fetchUserProfile();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  // ─── Logout Dialog ────────────────────────────────────────────────────────

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await ProfileController.logout();
              if (!context.mounted) return;
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E4A7A), Color(0xFF1E4A7A)],
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // ── Profile Header ──────────────────────────────────────────
                // Saat loading, tampilkan skeleton. Setelah selesai,
                // ProfileHeader langsung baca data dari ProfileController.
                _loading
                    ? const _ProfileHeaderSkeleton()
                    : const ProfileHeader(),

                // ── Tombol Logout ───────────────────────────────────────────
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
                    child: IconButton(
                      onPressed: () => _logout(context),
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.background,
                      ),
                      tooltip: "Logout",
                      padding: const EdgeInsets.all(10),
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

// ─── Skeleton saat loading ───────────────────────────────────────────────────

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 38, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
        ),
      ),
      child: Column(
        children: [
          // Back button placeholder
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Avatar placeholder
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 15),
          // Nama placeholder
          Container(
            width: 130,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          // Email placeholder
          Container(
            width: 180,
            height: 13,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}