import 'package:easylive_app/core/color.dart';
import 'package:flutter/material.dart';
import 'package:easylive_app/widgets/common/back_button_widget.dart';

import '../../../controllers/user/history_controller.dart';
import '../../../models/user/history_model.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import '../../../widgets/user/history/history_card.dart';
import '../../../widgets/user/history/history_empty_state.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedType = HistoryController.defaultType;

  // Semua history dari Supabase (Kost + Jasa digabung)
  List<HistoryItem> _allHistories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  Future<void> _loadHistories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final histories = await HistoryController.fetchAllHistories();
      if (mounted) {
        setState(() {
          _allHistories = histories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data. Coba lagi.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final histories = HistoryController.filterByType(_allHistories, selectedType);

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Header Area
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              child: Row(
                children: [
                  const BackButtonWidget(
                    backgroundColor: AppColors.yellow,
                    iconColor: AppColors.primary,
                    size: 44,
                    iconSize: 20,
                    borderRadius: 12,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'History',
                      style: TextStyle(
                        color: AppColors.golden,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  // Tombol refresh manual
                  if (!_isLoading)
                    IconButton(
                      onPressed: _loadHistories,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: Column(
                  children: [
                    // Filter Chips
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        children: [
                          ...HistoryController.historyTypes.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final type = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index ==
                                          HistoryController.historyTypes.length - 1
                                      ? 0
                                      : 12,
                                ),
                                child: _buildTypeChip(type),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(indent: 20, endIndent: 20, thickness: 1),

                    // List History
                    Expanded(
                      child: _buildContent(histories),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNav(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) return;
            if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else if (index == 2) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/booking', (route) => false);
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<HistoryItem> histories) {
    // State: loading
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.darkBlue),
      );
    }

    // State: error
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadHistories,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // State: empty
    if (histories.isEmpty) {
      return const HistoryEmptyState();
    }

    // State: data tersedia
    return RefreshIndicator(
      color: AppColors.darkBlue,
      onRefresh: _loadHistories,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: histories.length,
        itemBuilder: (context, index) {
          final item = histories[index];
          return HistoryCard(
            item: item,
            onTap: () => Navigator.pushNamed(
              context,
              '/history/detail',
              arguments: item,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    final isSelected = selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.darkBlue),
          color: isSelected ? AppColors.darkBlue : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}