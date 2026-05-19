import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/home_jasa_controller.dart';
import '../../../widgets/pemilikJasa/home/dashboard_widgets.dart';

class PemilikJasaHomeView extends StatelessWidget {
  PemilikJasaHomeView({super.key});

  final PemilikJasaHomeController controller = PemilikJasaHomeController();

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    } else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/profile');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PemilikJasaHomeFrame(
          totalVehicles: controller.totalVehicles,
          availableVehicles: controller.availableVehicles,
          totalIncome: controller.totalIncome,
          newBookings: controller.newBookings,
          availableRatio: controller.availableRatio,
          vehicles: controller.vehicles,
          onNavigate: (index) => _handleNavigation(context, index),
        ),
      ),
    );
  }
}
