import 'package:flutter/material.dart';

import '../../../controllers/admin/dashboard_controller.dart';
import '../../../widgets/admin/dashboard/dashboard_activity_tile.dart';
import '../../../widgets/admin/dashboard/dashboard_card.dart';
import '../../../widgets/admin/dashboard/dashboard_header.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/dashboard/dashboard_pending_action_card.dart';
import '../../../widgets/admin/dashboard/dashboard_quick_action.dart';
import '../../../widgets/admin/dashboard/dashboard_section_header.dart';

import '../../../models/admin/dashboard_model.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  final AdminHomeController controller = AdminHomeController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
      ({
        AdminDashboardModel dashboard,
        List<AdminDashboardStat> stats,
        List<AdminQuickAction> quickActions,
        List<AdminPendingAction> pendingActions,
        List<AdminRecentActivity> recentActivities,
      })
    >(
      future:
          Future.wait([
            controller.loadDashboardData(),
            controller.loadStats(),
            Future.value(controller.getQuickActions()),
            controller.loadPendingActions(),
            controller.loadRecentActivities(),
          ]).then((results) {
            return (
              dashboard: results[0] as AdminDashboardModel,
              stats: results[1] as List<AdminDashboardStat>,
              quickActions: results[2] as List<AdminQuickAction>,
              pendingActions: results[3] as List<AdminPendingAction>,
              recentActivities: results[4] as List<AdminRecentActivity>,
            );
          }),
      builder: (context, snapshot) {
        final hasData =
            snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData;

        final dashboard = hasData
            ? snapshot.data!.dashboard
            : controller.getDashboardData();
        final stats = hasData ? snapshot.data!.stats : controller.getStats();
        final quickActions = hasData
            ? snapshot.data!.quickActions
            : controller.getQuickActions();
        final pendingActions = hasData
            ? snapshot.data!.pendingActions
            : controller.getPendingActions();
        final recentActivities = hasData
            ? snapshot.data!.recentActivities
            : controller.getRecentActivities();

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8FA),
          body: SafeArea(
            child: Column(
              children: [
                const AdminHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF243447),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Admin Overview',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${dashboard.pendingApprovals} approval menunggu, ${dashboard.openReports} laporan perlu dicek',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        height: 1.3,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: stats.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.35,
                              ),
                          itemBuilder: (context, index) {
                            final stat = stats[index];
                            final icons = [
                              Icons.pending_actions_rounded,
                              Icons.home_work_rounded,
                              Icons.miscellaneous_services_rounded,
                              Icons.notifications_rounded,
                            ];
                            final colors = [
                              const Color(0xFFFF7A21),
                              const Color(0xFF2F80ED),
                              const Color(0xFF7B61FF),
                              const Color(0xFF0C7A3D),
                            ];

                            return AdminStatCard(
                              title: stat.title,
                              value: stat.value,
                              caption: stat.caption,
                              icon: icons[index],
                              iconColor: colors[index],
                              onTap: () =>
                                  Navigator.pushNamed(context, stat.routeName),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        AdminDashboardSectionHeader(
                          title: 'Quick Actions',
                          actionLabel: 'Notifikasi',
                          onActionTap: () =>
                              Navigator.pushNamed(context, '/admin/notifikasi'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            AdminQuickActionCard(
                              icon: Icons.fact_check_outlined,
                              title: quickActions[0].title,
                              subtitle: quickActions[0].subtitle,
                              onTap: () => Navigator.pushNamed(
                                context,
                                quickActions[0].routeName,
                              ),
                            ),
                            const SizedBox(width: 10),
                            AdminQuickActionCard(
                              icon: Icons.design_services_outlined,
                              title: quickActions[1].title,
                              subtitle: quickActions[1].subtitle,
                              onTap: () => Navigator.pushNamed(
                                context,
                                quickActions[1].routeName,
                              ),
                            ),
                            const SizedBox(width: 10),
                            AdminQuickActionCard(
                              icon: Icons.history_rounded,
                              title: quickActions[2].title,
                              subtitle: quickActions[2].subtitle,
                              onTap: () => Navigator.pushNamed(
                                context,
                                quickActions[2].routeName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AdminDashboardSectionHeader(
                          title: 'Pending Actions',
                          actionLabel: 'Lihat semua',
                          onActionTap: () =>
                              Navigator.pushNamed(context, '/admin/kos'),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 225,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: pendingActions.length,
                            itemBuilder: (context, index) {
                              final action = pendingActions[index];
                              final icons = [
                                Icons.home_work_outlined,
                                Icons.miscellaneous_services_outlined,
                                Icons.report_problem_outlined,
                              ];
                              final colors = [
                                const Color(0xFF2F80ED),
                                const Color(0xFF7B61FF),
                                const Color(0xFFE4251B),
                              ];

                              return AdminPendingActionCard(
                                title: action.title,
                                subtitle: action.subtitle,
                                status: action.status,
                                icon: icons[index % icons.length],
                                color: colors[index % colors.length],
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  action.routeName,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AdminBottomNavbar(
            selectedIndex: selectedIndex,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  setState(() => selectedIndex = index);
                  return;
                case 1:
                  Navigator.pushReplacementNamed(context, '/admin/history');
                  return;
                case 2:
                  Navigator.pushReplacementNamed(context, '/admin/kos');
                  return;
                case 3:
                  Navigator.pushReplacementNamed(context, '/admin/jasa');
                  return;
                case 4:
                  Navigator.pushReplacementNamed(context, '/admin/profile');
                  return;
                default:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Halaman belum tersedia')),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
