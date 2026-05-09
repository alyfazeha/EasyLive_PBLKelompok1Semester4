import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/dashboard_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/dashboard/dashboard_header.dart';
import '../../../widgets/pemilikJasa/dashboard/dashboard_payment.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class PemilikJasaDashboardView extends StatelessWidget {
  PemilikJasaDashboardView({super.key});

  final PemilikJasaDashboardController controller =
      PemilikJasaDashboardController();

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) return;

    if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                PemilikJasaDashboardHeader(
                  ownerName: controller.ownerName,
                  notificationCount: controller.notificationCount,
                  stats: controller.stats,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 104),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Riwayat Pembayaran',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final payment in controller.payments)
                          JasaPaymentHistoryCard(payment: payment),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: PemilikJasaBottomNav(
                currentIndex: 0,
                onNavigate: (index) => _handleNavigation(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
