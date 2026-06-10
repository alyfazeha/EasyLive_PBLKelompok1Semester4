import 'package:flutter/material.dart';

enum AdminNotificationType {
  kostApproval,
  jasaApproval,
}

class AdminNotification {
  final String id;
  final String title;
  final String description;
  final String time;
  final AdminNotificationType type;
  final bool isRead;
  final String? targetName;
  final String? actionLabel;
  final String? ownerName; // ← tambah ini

  const AdminNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
    this.targetName,
    this.actionLabel,
    this.ownerName, // ← tambah ini
  });

  AdminNotification copyWith({bool? isRead}) {
    return AdminNotification(
      id: id,
      title: title,
      description: description,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
      targetName: targetName,
      actionLabel: actionLabel,
      ownerName: ownerName,
    );
  }

  IconData get icon {
    switch (type) {
      case AdminNotificationType.kostApproval:
        return Icons.home_work_outlined;
      case AdminNotificationType.jasaApproval:
        return Icons.miscellaneous_services_outlined;
    }
  }

  Color get color {
    switch (type) {
      case AdminNotificationType.kostApproval:
        return const Color(0xFF2F80ED);
      case AdminNotificationType.jasaApproval:
        return const Color(0xFF7B61FF);
    }
  }
}

class AdminNotificationDetail {
  final AdminNotification notification;
  final String statusLabel;
  final String primaryInfoLabel;
  final String primaryInfoValue;
  final List<AdminNotificationDetailRow> rows;
  final String summary;
  final String primaryActionLabel;
  final String? secondaryActionLabel;

  const AdminNotificationDetail({
    required this.notification,
    required this.statusLabel,
    required this.primaryInfoLabel,
    required this.primaryInfoValue,
    required this.rows,
    required this.summary,
    required this.primaryActionLabel,
    this.secondaryActionLabel,
  });
}

class AdminNotificationDetailRow {
  final String label;
  final String value;

  const AdminNotificationDetailRow({required this.label, required this.value});
}