import 'package:flutter/material.dart';

import '../../../controllers/pemilikKos/detail_booking_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikKos/booking/detail_booking_widgets.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';

class DetailBookingView extends StatefulWidget {
  final String tenantName;

  const DetailBookingView({
    super.key,
    required this.tenantName,
  });

  @override
  State<DetailBookingView> createState() => _DetailBookingViewState();
}

class _DetailBookingViewState extends State<DetailBookingView> {
  late final DetailBookingController controller;

  @override
  void initState() {
    super.initState();
    controller = DetailBookingController(tenantName: widget.tenantName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
    }
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = controller.booking;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    onTap: _goBack,
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Detail Penyewa',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DetailBookingTenantHeader(booking: booking),
                      const SizedBox(height: 28),
                      DetailBookingInfoCard(booking: booking),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: OwnerBottomNav(
          currentIndex: 3,
          onNavigate: _navigateTo,
        ),
      ),
    );
  }
}
