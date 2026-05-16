import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/jasa/jasa_card.dart';
import '../../../widgets/common/back_button_widget.dart';

class AdminJasaManagementView extends StatefulWidget {
  const AdminJasaManagementView({super.key});

  @override
  State<AdminJasaManagementView> createState() =>
      _AdminJasaManagementViewState();
}

class _AdminJasaManagementViewState extends State<AdminJasaManagementView> {
  String _search = '';
  String _tab = 'all'; // all | active | inactive

  final List<_JasaItem> _items = const [
    _JasaItem(
      title: 'Jasa Pindah',
      subtitle: 'EasyMove Reguler',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_motor.png',
    ),
    _JasaItem(
      title: 'Laundry',
      subtitle: 'Bersih Laundry',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_laundry.png',
    ),
    _JasaItem(
      title: 'Cleaning Service',
      subtitle: 'Bersih Bersih Cleaning',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_cleaning.png',
    ),
    _JasaItem(
      title: 'Transport',
      subtitle: 'Prima Transport',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_transport.png',
    ),
  ];

  List<_JasaItem> get filtered {
    final q = _search.trim().toLowerCase();

    return _items.where((item) {
      final matchSearch =
          item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q);

      final matchTab = _tab == 'all'
          ? true
          : _tab == 'active'
          ? item.status.toLowerCase() == 'aktif' ||
                item.status.toLowerCase() == 'active'
          : item.status.toLowerCase() == 'inactive' ||
                item.status.toLowerCase() == 'tidak aktif';

      return matchSearch && matchTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (samakan tinggi & nyambung seperti halaman admin lain)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
              decoration: const BoxDecoration(
                color: Color(0xFF243447), // sama dengan AdminHeader
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  const BackButtonWidget(
                    backgroundColor: AppColors.yellow,
                    iconColor: AppColors.darkBlue,
                    size: 44,
                    iconSize: 20,
                    borderRadius: 14,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Jasa Management',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, '/admin/notifikasi'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content frame
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF0F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (v) => setState(() => _search = v),
                                decoration: const InputDecoration(
                                  hintText: 'Search host',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tabs
                      Row(
                        children: [
                          _TabChip(
                            label: 'All',
                            active: _tab == 'all',
                            onTap: () => setState(() => _tab = 'all'),
                          ),
                          const SizedBox(width: 10),
                          _TabChip(
                            label: 'Active',
                            active: _tab == 'active',
                            onTap: () => setState(() => _tab = 'active'),
                          ),
                          const SizedBox(width: 10),
                          _TabChip(
                            label: 'Inactive',
                            active: _tab == 'inactive',
                            onTap: () => setState(() => _tab = 'inactive'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text(
                                  'Tidak ada data',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  return JasaCard(
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    status: item.status,
                                    imageAsset: item.imageAsset,
                                    onTap: () {
                                      // placeholder detail navigation
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Detail: ${item.title}',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom navbar
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.zero,
              child: AdminBottomNavbar(
                selectedIndex: 3, // Jasa
                onItemTapped: (index) {
                  // index sesuai urutan di AdminBottomNavbar:
                  // 0 Dashboard, 1 History, 2 Kost, 3 Jasa, 4 Profile
                  if (index == 3) return;

                  switch (index) {
                    case 0:
                      Navigator.pushNamed(context, '/admin');
                      break;

                    case 1:
                      Navigator.pushNamed(context, '/admin/history');
                      break;

                    case 2:
                      Navigator.pushNamed(context, '/admin/kos');
                      break;

                    case 4:
                      Navigator.pushNamed(context, '/admin/profile');
                      break;

                    default:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Halaman belum tersedia')),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.yellow : const Color(0xFFEAF0F7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.yellow : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: active ? AppColors.darkBlue : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _JasaItem {
  final String title;
  final String subtitle;
  final String status;
  final String imageAsset;

  const _JasaItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.imageAsset,
  });
}
