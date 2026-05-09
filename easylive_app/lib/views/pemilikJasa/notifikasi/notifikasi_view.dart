import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/notifikasi_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';
import '../../../widgets/pemilikJasa/notifikasi/notifikasi_card.dart';
import '../../../widgets/pemilikJasa/notifikasi/notifikasi_filter_tabs.dart';

class OwnerJasaNotificationView extends StatefulWidget {
  const OwnerJasaNotificationView({super.key});

  @override
  State<OwnerJasaNotificationView> createState() => _OwnerJasaNotificationViewState();
}

class _OwnerJasaNotificationViewState extends State<OwnerJasaNotificationView> {
  final OwnerJasaNotificationController controller =
      OwnerJasaNotificationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    // Navbar pemilik jasa: kiri=dashboard, tengah=home, kanan=booking
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    }
  }

  void _goBack() {
    // Pastikan tidak ada background biru di belakang konten
    Navigator.pushReplacementNamed(context, '/pemilik_jasa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        color: AppColors.darkBlue,
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
                      color: AppColors.darkBlue,
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
                    final notifications = controller.notifications;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
                          child: OwnerJasaNotificationFilterTabs(
                            showUnreadOnly: controller.showUnreadOnly,
                            totalCount: controller.totalCount,
                            unreadCount: controller.unreadCount,
                            onShowAll: controller.showAll,
                            onShowUnread: controller.showUnread,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              18,
                              55,
                              18,
                              110,
                            ),
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              return OwnerJasaNotificationCard(
                                notification: notifications[index],
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

