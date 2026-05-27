import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/home_jasa_controller.dart';
import '../../../widgets/pemilikJasa/home/dashboard_widgets.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class PemilikJasaHomeView extends StatelessWidget {
  PemilikJasaHomeView({super.key});

  final PemilikJasaHomeController controller = PemilikJasaHomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // warna header & footer
      backgroundColor: const Color.fromRGBO(45, 62, 80, 1),

      body: Column(
        children: [
          // HEADER BIRU
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color.fromRGBO(45, 62, 80, 1),
          ),

          // HALAMAN TENGAH PUTIH
          Expanded(
            child: Container(
              color: Colors.white,

              // NAIKKAN NAVBAR SEDIKIT
              padding: const EdgeInsets.only(bottom: 8),

              child: SafeArea(
                top: false,
                child: PemilikJasaHomeFrame(
                  totalVehicles: controller.totalVehicles,
                  availableVehicles: controller.availableVehicles,
                  totalIncome: controller.totalIncome,
                  newBookings: controller.newBookings,
                  availableRatio: controller.availableRatio,
                  vehicles: controller.vehicles,
                  onNavigate: (index) {
                    // Navbar pemilik jasa:
                    // hanya Dashboard & Booking
                    if (index == 0) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/pemilik_jasa/dashboard',
                      );
                    } else if (index == 3) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/pemilik_jasa/booking',
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
