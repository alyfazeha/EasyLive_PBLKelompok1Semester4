import 'package:flutter/material.dart';
import '../../../controllers/pemilikJasa/notifikasi_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import '../../../widgets/pemilikJasa/notifikasi/notifikasi_card.dart';

class OwnerJasaNotificationView extends StatefulWidget {
  const OwnerJasaNotificationView({super.key});

  @override
  State<OwnerJasaNotificationView> createState() =>
      _OwnerJasaNotificationViewState();
}

class _OwnerJasaNotificationViewState
    extends State<OwnerJasaNotificationView> {
  late OwnerJasaNotificationController controller;

  @override
  void initState() {
    super.initState();
    controller = OwnerJasaNotificationController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    }
  }

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/pemilik_jasa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifikasi',
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    if (controller.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final notifications = controller.notifications;

                    return Column(
                      children: [
                        Expanded(
                          child: notifications.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.notifications_off_outlined,
                                        size: 40,
                                        color: Colors.black26,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Belum ada notifikasi',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    16,
                                    18,
                                    110,
                                  ),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/pemilik_jasa/notifikasi/detail',
                                          arguments: notification,
                                        );
                                      },
                                      child: OwnerJasaNotificationCard(
                                        notification: notification,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: PemilikJasaBottomNav(
          currentIndex: 2,
          onNavigate: _navigateTo,
        ),
      ),
    );
  }
}