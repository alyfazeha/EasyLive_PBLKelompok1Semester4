import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import '../../../../widgets/pemilikJasa/profile/profile_header.dart';
import '../../../../widgets/pemilikJasa/profile/profile_menu_section.dart';

class PemilikJasaProfileView extends StatefulWidget {
  const PemilikJasaProfileView({super.key});

  @override
  State<PemilikJasaProfileView> createState() => _PemilikJasaProfileViewState();
}

class _PemilikJasaProfileViewState extends State<PemilikJasaProfileView> {
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
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
                break;
              case 3:
                Navigator.pushReplacementNamed(
                  context,
                  '/pemilik_jasa/booking',
                );
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
                break;
              default:
                break;
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(children: [const PemilikJasaProfileHeader()]),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
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
      ),
    );
  }
}
