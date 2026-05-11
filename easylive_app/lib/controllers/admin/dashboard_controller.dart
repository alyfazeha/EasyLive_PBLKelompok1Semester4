import 'package:flutter/material.dart';

// ── Model ────────────────────────────────────────────
class DashboardData {
  final int pendingApprovals;
  final int approvedKost;
  final int approvedJasa;
  final int notifications;

  DashboardData({
    required this.pendingApprovals,
    required this.approvedKost,
    required this.approvedJasa,
    required this.notifications,
  });
}

class NotificationItemModel {
  final String title;
  final IconData icon;
  final Color color;

  NotificationItemModel({
    required this.title,
    required this.icon,
    required this.color,
  });
}

// ── Controller ───────────────────────────────────────
class AdminHomeController {
  DashboardData getDashboardData() {
    return DashboardData(
      pendingApprovals: 24,
      approvedKost: 128,
      approvedJasa: 59,
      notifications: 8,
    );
  }

  List<NotificationItemModel> getRecentNotifications() {
    return [
      NotificationItemModel(
        title: 'Laundry service updated',
        icon: Icons.local_laundry_service,
        color: Colors.amber,
      ),
      NotificationItemModel(
        title: 'New kost owner request',
        icon: Icons.home_work,
        color: Colors.green,
      ),
    ];
  }
}