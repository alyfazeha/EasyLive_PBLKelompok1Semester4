import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikJasa/dashboard_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/dashboard/dashboard_header.dart';
import '../../../widgets/pemilikJasa/dashboard/dashboard_payment.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class PemilikJasaDashboardView extends StatefulWidget {
  const PemilikJasaDashboardView({super.key});

  @override
  State<PemilikJasaDashboardView> createState() =>
      _PemilikJasaDashboardViewState();
}

class _PemilikJasaDashboardViewState extends State<PemilikJasaDashboardView> {
  late PemilikJasaDashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = PemilikJasaDashboardController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<PemilikJasaDashboardController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      PemilikJasaDashboardHeader(
                        ownerName: ctrl.ownerName,
                        notificationCount: ctrl.notificationCount,
                        stats: ctrl.stats,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(16, 12, 16, 104),
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
                              if (ctrl.payments.isEmpty)
                                const Center(
                                  child: Text(
                                    'Belum ada riwayat pembayaran',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black45,
                                    ),
                                  ),
                                )
                              else
                                for (final payment in ctrl.payments)
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
                      onNavigate: (index) =>
                          _handleNavigation(context, index),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}