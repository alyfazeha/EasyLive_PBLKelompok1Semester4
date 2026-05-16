class AdminDashboardModel {
  final int pendingApprovals;
  final int approvedKost;
  final int approvedJasa;
  final int notifications;
  final int openReports;
  final String weeklyRevenue;

  const AdminDashboardModel({
    required this.pendingApprovals,
    required this.approvedKost,
    required this.approvedJasa,
    required this.notifications,
    required this.openReports,
    required this.weeklyRevenue,
  });
}

class AdminDashboardStat {
  final String title;
  final String value;
  final String caption;
  final String routeName;

  const AdminDashboardStat({
    required this.title,
    required this.value,
    required this.caption,
    required this.routeName,
  });
}

class AdminQuickAction {
  final String title;
  final String subtitle;
  final String routeName;

  const AdminQuickAction({
    required this.title,
    required this.subtitle,
    required this.routeName,
  });
}

class AdminPendingAction {
  final String title;
  final String subtitle;
  final String status;
  final String routeName;

  const AdminPendingAction({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.routeName,
  });
}

class AdminRecentActivity {
  final String title;
  final String subtitle;
  final String time;
  final String routeName;

  const AdminRecentActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.routeName,
  });
}
