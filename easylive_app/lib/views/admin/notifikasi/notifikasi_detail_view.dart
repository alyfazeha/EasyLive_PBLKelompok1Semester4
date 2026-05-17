import 'package:flutter/material.dart';

import '../../../controllers/admin/notifikasi/notifikasi_detail_controller.dart';
import '../../../models/admin/notifikasi/notifikasi_model.dart';
import '../../../widgets/admin/notifikasi/notifikasi_detail_actions.dart';
import '../../../widgets/admin/notifikasi/notifikasi_detail_header.dart';
import '../../../widgets/admin/notifikasi/notifikasi_detail_info_card.dart';

class AdminNotificationDetailView extends StatelessWidget {
  final AdminNotification notification;

  const AdminNotificationDetailView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = AdminNotificationDetailController();
    final detail = controller.getDetail(notification);

    return Scaffold(
      backgroundColor: const Color(0xFF243447),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
                  const Expanded(
                    child: Text(
                      'Detail Notifikasi',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                  child: Column(
                    children: [
                      AdminNotificationDetailHeader(detail: detail),
                      const SizedBox(height: 14),
                      AdminNotificationDetailInfoCard(detail: detail),
                      const SizedBox(height: 20),
                      AdminNotificationDetailActions(
                        primaryLabel: detail.primaryActionLabel,
                        secondaryLabel: detail.secondaryActionLabel,
                        onPrimaryPressed: () {
                          Navigator.pushNamed(
                            context,
                            controller.routeFor(notification.type),
                          );
                        },
                        onSecondaryPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifikasi ditandai selesai'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
