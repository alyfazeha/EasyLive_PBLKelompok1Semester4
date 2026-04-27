import 'package:easylive_app/core/color.dart';
import 'package:flutter/material.dart';

import '../../controllers/history_controller.dart';
import '../../widgets/home/bottom_navbar.dart';
import '../../widgets/history/history_card.dart';
import '../../widgets/history/history_empty_state.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedType = HistoryController.defaultType;

  @override
  Widget build(BuildContext context) {
    final histories = HistoryController.getHistoriesByType(selectedType);

    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50), // Biru Tua Header
      body: SafeArea(
        child: Column(
          children: [
            // Header Area
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD141), // Kuning
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2D3E50),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'History',
                      style: TextStyle(
                        color: Color(0xFFFFD141),
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 28,
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
                                  right:
                                      index ==
                                          HistoryController
                                                  .historyTypes
                                                  .length -
                                              1
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
                      child: histories.isEmpty
                          ? const HistoryEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                context,
                '/home',
                (route) => false,
              );
            } else if (index == 2) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/booking',
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    bool isSelected = selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2D3E50)),
          color: isSelected ? const Color(0xFF2D3E50) : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2D3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
