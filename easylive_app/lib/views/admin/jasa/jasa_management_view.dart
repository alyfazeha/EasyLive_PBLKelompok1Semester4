import 'package:flutter/material.dart';

import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/jasa/jasa_card.dart';
import '../../../widgets/admin/kos/approval_tab_filter.dart';
import 'detail_jasa_view.dart';

class AdminJasaManagementView extends StatefulWidget {
  const AdminJasaManagementView({super.key});

  @override
  State<AdminJasaManagementView> createState() =>
      _AdminJasaManagementViewState();
}

class _AdminJasaManagementViewState extends State<AdminJasaManagementView> {
  final List<String> tabs = ['All', 'Pending', 'Approved', 'Rejected'];

  int selectedTabIndex = 0;

  List<_JasaItem> _items = const [
    _JasaItem(
      title: 'Jasa Pindah',
      subtitle: 'EasyMove Reguler',
      submittedDate: '12 Mei 2026',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_motor.png',
    ),
    _JasaItem(
      title: 'Laundry',
      subtitle: 'Bersih Laundry',
      submittedDate: '10 Mei 2026',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_laundry.png',
    ),
    _JasaItem(
      title: 'Cleaning Service',
      subtitle: 'Bersih Bersih Cleaning',
      submittedDate: '08 Mei 2026',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_cleaning.png',
    ),
    _JasaItem(
      title: 'Transport',
      subtitle: 'Prima Transport',
      submittedDate: '05 Mei 2026',
      status: 'pending',
      imageAsset: 'assets/images/jasa_icon_transport.png',
    ),
  ];

  List<_JasaItem> get filteredRequests {
    if (selectedTabIndex == 0) {
      return _items;
    }

    final selectedStatus = tabs[selectedTabIndex];

    return _items.where((item) {
      return item.status.toLowerCase() == selectedStatus.toLowerCase();
    }).toList();
  }

  void _updateStatus(_JasaItem item, String status) {
    setState(() {
      _items = _items.map((current) {
        if (current.title == item.title && current.subtitle == item.subtitle) {
          return current.copyWith(
            status: status,
            rejectionReason: status.toLowerCase() == 'rejected'
                ? current.rejectionReason
                : '',
          );
        }
        return current;
      }).toList();
    });
  }

  void _rejectWithReason(_JasaItem item, String reason) {
    setState(() {
      _items = _items.map((current) {
        if (current.title == item.title && current.subtitle == item.subtitle) {
          return current.copyWith(status: 'rejected', rejectionReason: reason);
        }
        return current;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF243B55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6BE00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Color(0xFF243447),
                        ),
                      ),
                    ),
                    const Text(
                      'Jasa Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/admin/notifikasi'),
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 28,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '9',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ApprovalTabFilter(
                  tabs: tabs,
                  selectedIndex: selectedTabIndex,
                  onTap: (index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(
                    child: Text(
                      'No jasa requests found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'Jasa Owner Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...filteredRequests.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: JasaCard(
                            title: item.title,
                            subtitle: item.subtitle,
                            submittedDate: item.submittedDate,
                            status: item.status,
                            imageAsset: item.imageAsset,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminJasaDetailView(
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    submittedDate: item.submittedDate,
                                    status: item.status,
                                    imageAsset: item.imageAsset,
                                    rejectionReason: item.rejectionReason,
                                  ),
                                ),
                              );

                              if (result is Map &&
                                  result['status'] == 'approved') {
                                _updateStatus(item, 'approved');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.subtitle} approved'),
                                  ),
                                );
                              } else if (result is Map &&
                                  result['status'] == 'rejected') {
                                _rejectWithReason(
                                  item,
                                  result['reason']?.toString() ?? '',
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.subtitle} rejected'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 3,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/admin');
              return;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/history');
              return;
            case 2:
              Navigator.pushReplacementNamed(context, '/admin/kos');
              return;
            case 3:
              return;
            case 4:
              Navigator.pushReplacementNamed(context, '/admin/profile');
              return;
          }
        },
      ),
    );
  }
}

class _JasaItem {
  final String title;
  final String subtitle;
  final String submittedDate;
  final String status;
  final String imageAsset;
  final String rejectionReason;

  const _JasaItem({
    required this.title,
    required this.subtitle,
    required this.submittedDate,
    required this.status,
    required this.imageAsset,
    this.rejectionReason = '',
  });

  _JasaItem copyWith({
    String? title,
    String? subtitle,
    String? submittedDate,
    String? status,
    String? imageAsset,
    String? rejectionReason,
  }) {
    return _JasaItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      submittedDate: submittedDate ?? this.submittedDate,
      status: status ?? this.status,
      imageAsset: imageAsset ?? this.imageAsset,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
