import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../controllers/pemilikKos/dashboard_controller.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_header.dart';
import '../../../widgets/pemilikKos/dashboard/dashboard_payment.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
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
          /// 🔥 HEADER
          const DashboardHeader(),

          /// 🔥 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 70, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 1),

                  /// 🔥 RIWAYAT PEMBAYARAN
                  const Text(
                    "Riwayat Pembayaran",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBlue,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// CARD LIST
                  const PaymentHistoryCard(
                    name: "Budi Santoso (Kamar 03)",
                    kost: "Daniska Kos",
                    date: "01 Mei 2026",
                    price: "Rp 5.500.000",
                    status: "Lunas",
                  ),

                  const PaymentHistoryCard(
                    name: "Andi Wijaya (Kamar 07)",
                    kost: "Daniska Kos",
                    date: "28 Ags 2026",
                    price: "Rp 5.500.000",
                    status: "Lunas",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🔥 BOTTOM NAV
      bottomNavigationBar: OwnerBottomNav(
        currentIndex: 0,
        onNavigate: (index) {
          if (index == 0) return;

          if (index == 3) {
            Navigator.pushReplacementNamed(
                context, '/pemilik_kos/history');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(
                context, '/pemilik_kos');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ComingSoonView(title: "Halaman"),
              ),
            );
          }
        },
      ),
    );
  }
}