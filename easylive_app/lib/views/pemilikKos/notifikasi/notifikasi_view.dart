import 'package:flutter/material.dart';

import '../../../controllers/pemilikKos/notifikasi_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../../../widgets/pemilikKos/notifikasi/notifikasi_card.dart';
import '../../../widgets/pemilikKos/notifikasi/notifikasi_filter_tabs.dart';

class OwnerNotificationView extends StatefulWidget {
  const OwnerNotificationView({super.key});

  @override
  State<OwnerNotificationView> createState() => _OwnerNotificationViewState();
}

class _OwnerNotificationViewState extends State<OwnerNotificationView> {
  final OwnerNotificationController controller =
      OwnerNotificationController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/pemilik_kos');
    }
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
                    final notifications = controller.notifications;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
                          child: OwnerNotificationFilterTabs(
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
                              return OwnerNotificationCard(
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
        child: OwnerBottomNav(
          currentIndex: 2,
          onNavigate: _navigateTo,
        ),
      ),
    );
  }
}
