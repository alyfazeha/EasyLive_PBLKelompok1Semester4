import 'package:flutter/material.dart';

import '../../../controllers/admin/history_controller.dart';
import '../../../models/admin/history_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/history/item_card.dart';
import '../../../widgets/admin/history/searching.dart';
import '../../../widgets/admin/history/filtering.dart';

class AdminHistoryView extends StatefulWidget {
  const AdminHistoryView({super.key});

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  final AdminHistoryController controller = AdminHistoryController();

  int selectedTab = 0;
  int selectedNavbar = 0; // History

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final tabs = controller.getTabs();
    final historyItems = controller.getHistoryItems();

    // =====================================================
    // FILTER DATA BERDASARKAN TAB YANG DIPILIH
    // =====================================================
    List<HistoryItemModel> filteredItems;

    switch (selectedTab) {
      case 1: // Kos
        filteredItems = historyItems.where((item) {
          return item.title.toLowerCase().contains('kos');
        }).toList();
        break;

      case 2: // Jasa
        filteredItems = historyItems.where((item) {
          return item.title.toLowerCase().contains('jasa') ||
              item.title.toLowerCase().contains('laundry');
        }).toList();
        break;

      case 3: // Laporan
        filteredItems = historyItems.where((item) {
          return item.title.toLowerCase().contains('laporan');
        }).toList();
        break;

      default: // Semua
        filteredItems = historyItems;
    }

    // Search (realtime)
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        return item.title.toLowerCase().contains(q) ||
            item.subtitle.toLowerCase().contains(q) ||
            item.date.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      // ================= HEADER =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF243447),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 20,
          toolbarHeight: 120,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                // Tombol Back
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6BE00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF243447),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Judul
                const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              HistorySearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              HistoryFilterTabs(
                tabs: tabs,
                selectedIndex: selectedTab,
                onTap: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada data history',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return HistoryItemCard(
                            item: filteredItems[index],
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/admin/history/detail',
                                arguments: filteredItems[index],
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

      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: selectedNavbar,
        onItemTapped: (index) {
          // Hanya route admin yang tersedia:
          // 0 History -> /admin/history
          // 1 Kos Approval -> /admin/kos_approval
          // 2 Dashboard -> /admin/home
          if (index == 0) {
            Navigator.pushNamed(context, '/admin/history');
            return;
          }
          if (index == 1) {
            Navigator.pushNamed(context, '/admin/kos_approval');
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/admin/home');
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu ini belum tersedia untuk Admin')),
          );
        },
      ),
    );
  }
}
