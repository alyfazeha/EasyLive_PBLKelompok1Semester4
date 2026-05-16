import 'package:flutter/material.dart';

<<<<<<< HEAD
import '../../../controllers/pemilikKos/notifikasi_controller.dart';
import '../../../core/color.dart';
import '../../../views/pemilikKos/notifikasi/notifikasi_detail_view.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';
import '../../../widgets/pemilikKos/notifikasi/notifikasi_card.dart';
import '../../../widgets/pemilikKos/notifikasi/notifikasi_filter_tabs.dart';

class OwnerNotificationView extends StatefulWidget {
  const OwnerNotificationView({super.key});

  @override
  State<OwnerNotificationView> createState() =>
      _OwnerNotificationViewState();
}

class _OwnerNotificationViewState extends State<OwnerNotificationView> {
  final OwnerNotificationController controller =
      OwnerNotificationController();
=======
import '../../../controllers/admin/notifikasi/notifikasi_controller.dart';
import '../../../widgets/admin/notifikasi/notifikasi_card.dart';
import '../../../widgets/admin/notifikasi/notifikasi_empty_state.dart';
import '../../../widgets/admin/notifikasi/notifikasi_filter_tabs.dart';
import 'notifikasi_detail_view.dart';

class AdminNotificationView extends StatefulWidget {
  const AdminNotificationView({super.key});

  @override
  State<AdminNotificationView> createState() => _AdminNotificationViewState();
}

class _AdminNotificationViewState extends State<AdminNotificationView> {
  final AdminNotificationController controller = AdminNotificationController();
>>>>>>> rafi

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/pemilik_kos/dashboard',
      );
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
        context,
        '/pemilik_kos',
      );
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        '/pemilik_kos/history',
      );
    }
  }

=======
>>>>>>> rafi
  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
<<<<<<< HEAD
      Navigator.pushReplacementNamed(
        context,
        '/pemilik_kos',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
=======
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  void _handleTap(int index) {
    final notification = controller.notifications[index];
    final id = notification.id;
    controller.markAsRead(id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminNotificationDetailView(
          notification: notification.copyWith(isRead: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF243447),
>>>>>>> rafi
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
<<<<<<< HEAD
                    'Notifikasi',
=======
                    'Notifikasi Admin',
>>>>>>> rafi
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
<<<<<<< HEAD
                    animation: controller,
                    builder: (context, _) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

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
                                    padding: const EdgeInsets.fromLTRB(18, 55, 18, 110),
                                    itemCount: notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = notifications[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => NotificationDetailView(
                                                ownerNotification: notification, // ← kirim notifikasi
                                              ),
                                            ),
                                          );
                                        },
                                        child: OwnerNotificationCard(
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
=======
                  animation: controller,
                  builder: (context, _) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notifications = controller.notifications;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
                          child: AdminNotificationFilterTabs(
                            showUnreadOnly: controller.showUnreadOnly,
                            totalCount: controller.totalCount,
                            unreadCount: controller.unreadCount,
                            onShowAll: controller.showAll,
                            onShowUnread: controller.showUnread,
                          ),
                        ),
                        Expanded(
                          child: notifications.isEmpty
                              ? const AdminNotificationEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    28,
                                    18,
                                    28,
                                  ),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    return AdminNotificationCard(
                                      notification: notification,
                                      onTap: () => _handleTap(index),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
>>>>>>> rafi
              ),
            ),
          ],
        ),
      ),
<<<<<<< HEAD
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
=======
    );
  }
}
>>>>>>> rafi
