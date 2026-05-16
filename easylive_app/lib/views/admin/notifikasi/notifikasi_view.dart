import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
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
                    'Notifikasi Admin',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
