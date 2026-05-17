import 'package:flutter/material.dart';

import '../../../controllers/admin/history_controller.dart';
import '../../../models/admin/history_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/history/item_card.dart';
import '../../../widgets/admin/history/searching.dart';
import '../../../widgets/admin/history/filtering.dart';
import '../../../widgets/common/back_button_widget.dart';

class AdminHistoryView extends StatefulWidget {
  const AdminHistoryView({super.key});

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  final AdminHistoryController controller = AdminHistoryController();

  int selectedTab = 0;
  int selectedNavbar = 1; // History

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
                const BackButtonWidget(
                  backgroundColor: Color(0xFFF6BE00),
                  iconColor: Color(0xFF243447),
                  size: 42,
                  iconSize: 18,
                  borderRadius: 12,
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

      // ================= BODY =================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return HistoryItemCard(
                            item: filteredItems[index],
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(filteredItems[index].title),
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

      // ================= BOTTOM NAVBAR =================
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: selectedNavbar,
        onItemTapped: (index) {
          // index sesuai urutan di AdminBottomNavbar:
          // 0 Dashboard, 1 History, 2 Kost, 3 Jasa, 4 Profile
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/admin');
              return;

            case 1:
              // tetap di halaman history
              setState(() => selectedNavbar = index);
              return;

            case 2:
              Navigator.pushNamed(context, '/admin/kos');
              return;

            case 3:
              Navigator.pushNamed(context, '/admin/jasa');
              return;

            case 4:
              Navigator.pushNamed(context, '/admin/profile');
              return;

            default:
              return;
          }
        },
      ),
    );
  }
}
