import 'package:flutter/material.dart';
import '../../../controllers/admin/history_controller.dart';
import '../../../models/admin/history_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/history/item_card.dart';
import '../../../widgets/admin/history/searching.dart';
import '../../../widgets/admin/history/filtering.dart';
import '../../../widgets/common/back_button_widget.dart';
import '../history/history_detail_view.dart';

class AdminHistoryView extends StatefulWidget {
  const AdminHistoryView({super.key});

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  final AdminHistoryController controller = AdminHistoryController();

  int selectedTab = 0;
  int selectedNavbar = 1;
  String _searchQuery = '';
  List<HistoryItemModel> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final items = await controller.getHistoryItems();
    setState(() {
      _allItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = controller.getTabs();

    // Filter berdasarkan tab
    List<HistoryItemModel> filteredItems;
    switch (selectedTab) {
      case 1:
        filteredItems =
            _allItems.where((item) => item.type == 'kos').toList();
        break;
      case 2:
        filteredItems =
            _allItems.where((item) => item.type == 'jasa').toList();
        break;
      default:
        filteredItems = _allItems;
    }

    // Search
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        return item.title.toLowerCase().contains(q) ||
            item.subtitle.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                BackButtonWidget(
                  backgroundColor: const Color(0xFFF6BE00),
                  iconColor: const Color(0xFF243447),
                  size: 42,
                  iconSize: 18,
                  borderRadius: 12,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/admin',
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(width: 12),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              HistorySearchBar(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
              const SizedBox(height: 16),
              HistoryFilterTabs(
                tabs: tabs,
                selectedIndex: selectedTab,
                onTap: (index) {
                  setState(() => selectedTab = index);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada data history',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadData,
                            child: ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return HistoryItemCard(
                                  item: filteredItems[index],
                                  onTap: () {
                                    // ← navigasi ke detail
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AdminHistoryDetailView(
                                          historyItem: filteredItems[index],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: selectedNavbar,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/admin');
              return;
            case 1:
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
          }
        },
      ),
    );
  }
}