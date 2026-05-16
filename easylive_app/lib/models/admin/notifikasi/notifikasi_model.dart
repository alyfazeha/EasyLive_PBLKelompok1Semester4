import 'package:flutter/material.dart';

enum AdminNotificationType {
  kostApproval,
  jasaApproval,
  payment,
  report,
  system,
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

  const AdminNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isRead = false,
    this.targetName,
    this.actionLabel,
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
    );
  }

  IconData get icon {
    switch (type) {
      case AdminNotificationType.kostApproval:
        return Icons.home_work_outlined;
      case AdminNotificationType.jasaApproval:
        return Icons.miscellaneous_services_outlined;
      case AdminNotificationType.payment:
        return Icons.payments_outlined;
      case AdminNotificationType.report:
        return Icons.report_problem_outlined;
      case AdminNotificationType.system:
        return Icons.admin_panel_settings_outlined;
    }
  }

  Color get color {
    switch (type) {
      case AdminNotificationType.kostApproval:
        return const Color(0xFF2F80ED);
      case AdminNotificationType.jasaApproval:
        return const Color(0xFF7B61FF);
      case AdminNotificationType.payment:
        return const Color(0xFF0C7A3D);
      case AdminNotificationType.report:
        return const Color(0xFFE4251B);
      case AdminNotificationType.system:
        return const Color(0xFFFF7A21);
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
