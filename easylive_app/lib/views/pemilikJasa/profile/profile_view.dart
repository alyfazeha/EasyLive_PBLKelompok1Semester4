import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../../../controllers/auth_controller.dart';
import '../../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import '../../../../widgets/pemilikJasa/profile/profile_header.dart';
import '../../../../widgets/pemilikJasa/profile/profile_menu_section.dart';

class PemilikJasaProfileView extends StatefulWidget {
  const PemilikJasaProfileView({super.key});

  @override
  State<PemilikJasaProfileView> createState() =>
      _PemilikJasaProfileViewState();
}

class _PemilikJasaProfileViewState
    extends State<PemilikJasaProfileView> {
  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AuthController.logout();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
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

      bottomNavigationBar: SafeArea(
        top: false,
        child: PemilikJasaBottomNav(
          currentIndex: 4,
          onNavigate: (index) {
            if (index == 4) return;

            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa/dashboard',
                );
                break;

              case 1:
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa',
                );
                break;

              case 2:
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa',
                );
                break;

              case 3:
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa/booking',
                );
                break;

              default:
                break;
            }
          },
        ),
      ),

      body: Column(
        children: [
          Stack(
            children: [
              const PemilikJasaProfileHeader(),

              Positioned(
                top: MediaQuery.of(context).padding.top + 31,
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
                    tooltip: 'Logout',
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBlue,
                      blurRadius: 22,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: PemilikJasaProfileMenuSection(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
