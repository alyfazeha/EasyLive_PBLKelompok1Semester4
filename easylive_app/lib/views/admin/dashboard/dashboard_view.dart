import 'package:flutter/material.dart';

import '../../../controllers/admin/dashboard_controller.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/dashboard/dashboard_header.dart';
import '../../../widgets/admin/dashboard/notifikasi_item.dart';
import '../../../widgets/admin/dashboard/dashboard_card.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  final AdminHomeController controller = AdminHomeController();
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final dashboard = controller.getDashboardData();
    final notifications = controller.getRecentNotifications();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AdminHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── STAT CARDS ──────────────────────────────
                    // Ganti GridView.count → Column + Row
                    // supaya tinggi card mengikuti konten
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
          // Sesuai flow: History selalu membuka halaman /admin/history
          if (index == 0) {
            Navigator.pushNamed(context, '/admin/history');
            // jangan update selectedIndex dulu supaya state tetap konsisten
            return;
          }

          setState(() => selectedIndex = index);
          // Navigasi Admin:
          // index 1 (Kos Approval) menampilkan kos_approval_view
          if (index == 1) {
            Navigator.pushNamed(context, '/admin/kos_approval');
            return;
          }
          // index 2..4: TODO sesuai kebutuhan
        },
      ),
    );
  }
}
