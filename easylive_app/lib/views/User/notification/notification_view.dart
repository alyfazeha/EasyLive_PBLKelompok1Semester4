import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/color.dart';
import '../../../models/user/user_notification_model.dart';
import '../../../controllers/user/user_notification_controller.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserNotificationController(),
      child: const _NotificationContent(),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserNotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.darkBlue,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      color: AppColors.golden,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const Spacer(),
                  // Tombol refresh
                  GestureDetector(
                    onTap: controller.loadData,
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.yellow,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Body ─────────────────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: _buildBody(controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(UserNotificationController controller) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.darkBlue),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Coba Lagi',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off_outlined,
                size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Belum ada notifikasi',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Update status booking akan muncul di sini',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      itemCount: controller.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = controller.notifications[index];
        return _NotificationCard(item: item);
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final UserNotification item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final iconData = _iconFromSource(item.source);
    final iconBg = _iconBgFromType(item.type);
    final iconColor = _iconColorFromType(item.type);
    final badgeColor = _badgeColorFromType(item.type);
    final badgeLabel = _badgeLabelFromType(item.type);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Icon ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),

          // ─── Teks ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.darkBlue,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                // Label sumber booking
                Row(
                  children: [
                    Icon(
                      item.source == BookingSource.kos
                          ? Icons.home_rounded
                          : Icons.directions_car_rounded,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.source == BookingSource.kos
                          ? 'Booking Kos'
                          : 'Booking Jasa',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  IconData _iconFromSource(BookingSource source) {
    return source == BookingSource.kos
        ? Icons.home_rounded
        : Icons.directions_car_rounded;
  }

  Color _iconBgFromType(UserNotificationType type) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return Colors.green.shade50;
      case UserNotificationType.ditolak:
        return Colors.red.shade50;
      case UserNotificationType.selesai:
        return AppColors.yellow.withOpacity(0.2);
    }
  }

  Color _iconColorFromType(UserNotificationType type) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return Colors.green.shade600;
      case UserNotificationType.ditolak:
        return Colors.red.shade400;
      case UserNotificationType.selesai:
        return AppColors.darkBlue;
    }
  }

  Color _badgeColorFromType(UserNotificationType type) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return Colors.green.shade600;
      case UserNotificationType.ditolak:
        return Colors.red.shade400;
      case UserNotificationType.selesai:
        return Colors.orange.shade600;
    }
  }

  String _badgeLabelFromType(UserNotificationType type) {
    switch (type) {
      case UserNotificationType.dikonfirmasi:
        return 'Dikonfirmasi';
      case UserNotificationType.ditolak:
        return 'Ditolak';
      case UserNotificationType.selesai:
        return 'Selesai';
    }
  }
}