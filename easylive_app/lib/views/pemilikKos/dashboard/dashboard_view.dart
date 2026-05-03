import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/dashboard_controller.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_header.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_item.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../booking/booking_view.dart';
import '../comingSoon_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final controller = DashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: Column(
        children: [
          /// 🔥 HEADER (BIRU)
          const DashboardHeader(),

          /// 🔥 CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "Belum ada aktivitas",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: OwnerBottomNav(
        currentIndex: 0,
        onNavigate: (index) {
          if (index == 0) return; // Already on dashboard

          if (index == 3) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/pemilik_kos');
          } else {
            String title;
            switch (index) {
              case 1:
                title = 'Riwayat';
                break;
              case 4:
                title = 'Profil';
                break;
              default:
                title = 'Halaman';
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComingSoonView(title: title),
              ),
            );
          }
        },
      ),
    );
  }
}
