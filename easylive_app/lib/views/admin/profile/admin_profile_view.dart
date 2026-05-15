import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/common/back_button_widget.dart';

import '../../../widgets/admin/dashboard/navbar_button.dart';

class AdminProfileView extends StatefulWidget {
  const AdminProfileView({super.key});

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  static const _navy = Color(0xFF243447);
  static const _yellow = Color(0xFFF6BE00);

  Future<void> _logout() async {
    await AuthController.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Top bar (menu + title + bell) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.menu, color: _navy),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Admin Profile',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.notifications, color: _navy),
                  ),
                ],
              ),
            ),

            // ===== Main white card =====
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    // Back + title area (optional: keep simple like screenshot)
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackButtonWidget(
                        backgroundColor: Colors.white,
                        iconColor: _navy,
                        size: 44,
                        iconSize: 20,
                        borderRadius: 12,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ===== Profile summary card =====
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.08),
                              ),
                              color: const Color(0xFFF2F2F2),
                            ),
                            child: const Icon(Icons.person,
                                size: 30, color: _navy),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Budi Santoso',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: _navy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'admin@easyjasa.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _yellow.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: _yellow.withOpacity(0.65),
                                    ),
                                  ),
                                  child: const Text(
                                    'Super Admin',
                                    style: TextStyle(
                                      color: _navy,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ===== Menu list =====
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ),
                        child: Column(
                          children: [
                            _MenuRow(
                              icon: Icons.person_outline,
                              title: 'Profile Information',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/admin/profile_information',
                                );
                              },
                            ),
                            _MenuRow(
                              icon: Icons.lock_outline,
                              title: 'Ubah Password',
                              onTap: () {
                                // belum ada route spesifik: placeholder
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ubah Password belum tersedia'),
                                  ),
                                );
                              },
                            ),
                            _MenuRow(
                              icon: Icons.notifications_active_outlined,
                              title: 'Notification Settings',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Notification Settings belum tersedia',
                                    ),
                                  ),
                                );
                              },
                            ),
                            _MenuRow(
                              icon: Icons.settings_outlined,
                              title: 'App Settings',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('App Settings belum tersedia'),
                                  ),
                                );
                              },
                            ),
                            _MenuRow(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Help & Support belum tersedia'),
                                  ),
                                );
                              },
                            ),

                            const Divider(height: 1),

                            // Logout button area
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _logout,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.logout, color: Colors.red),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // keep bottom navbar like existing admin pages
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 4) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/history');
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman Kost (Admin) belum tersedia'),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin/jasa');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF243447), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF243447),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
