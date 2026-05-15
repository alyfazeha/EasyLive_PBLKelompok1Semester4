import 'package:flutter/material.dart';

import '../../../controllers/admin/dashboard_controller.dart';
import '../../../widgets/admin/dashboard/dashboard_card.dart';
import '../../../widgets/admin/dashboard/dashboard_header.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';

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
    final dashboard = controller.getDashboardData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AdminHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AdminStatCard(
                                title: 'Pending Approvals',
                                value: dashboard.pendingApprovals,
                                icon: Icons.access_time,
                                iconColor: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AdminStatCard(
                                title: 'Approved Kost',
                                value: dashboard.approvedKost,
                                icon: Icons.verified,
                                iconColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AdminStatCard(
                                title: 'Approved Jasa',
                                value: dashboard.approvedJasa,
                                icon: Icons.verified,
                                iconColor: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AdminStatCard(
                                title: 'Notifications',
                                value: dashboard.notifications,
                                icon: Icons.notifications_none,
                                iconColor: const Color(0xFF243447),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman Kost (Admin) belum tersedia'),
                ),
              );
              setState(() => selectedIndex = index);
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
  }
}
