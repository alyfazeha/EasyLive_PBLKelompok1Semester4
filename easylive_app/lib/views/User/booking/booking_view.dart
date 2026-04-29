import 'package:flutter/material.dart';
import '../../../controllers/booking_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/booking/booking_card.dart';
import '../../../widgets/booking/booking_empty_state.dart';
import '../../../widgets/booking/booking_filter_chip.dart';
import '../../../widgets/home/bottom_navbar.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  String selectedType = 'Kost';
  String selectedStatus = 'Active Now'; // Default tab

  @override
  Widget build(BuildContext context) {
    // Memanggil controller dengan dua filter
    final filteredBookings = BookingController.getFilteredBookings(
      selectedType,
      selectedStatus,
    );

    return Scaffold(
      backgroundColor: AppColors.darkBlue, // Biru Tua Header
      body: SafeArea(
        child: Column(
          children: [
            // Header Area (Sesuai Mockup)
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
                        color: AppColors.golden, // Kuning
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.darkBlue,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'My Bookings',
                      style: TextStyle(
                        color: AppColors.golden,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.golden,
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
                    // Tabs Status (Active Now, Completed, Canceled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusTab('Active Now'),
                          _buildStatusTab('Completed'),
                          _buildStatusTab('Canceled'),
                        ],
                      ),
                    ),
                    const Divider(indent: 20, endIndent: 20, thickness: 1),

                    // Filter Kost / Jasa
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          _buildTypeChip('Kost'),
                          const SizedBox(width: 10),
                          _buildTypeChip('Jasa'),
                        ],
                      ),
                    ),

                    // List Booking
                    Expanded(
                      child: filteredBookings.isEmpty
                          ? BookingEmptyState(
                              message: BookingController.getEmptyMessage(
                                selectedStatus,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: filteredBookings.length,
                              itemBuilder: (context, index) {
                                return BookingCard(
                                  booking: filteredBookings[index],
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
          currentIndex: 2,
          onTap: (index) {
            if (index == 2) return;

            if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            } else if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/history',
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusTab(String label) {
    bool isSelected = selectedStatus == label;
    return GestureDetector(
      onTap: () => setState(() => selectedStatus = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: isSelected
                ? BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                color: isSelected ? AppColors.darkBlue : Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
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
