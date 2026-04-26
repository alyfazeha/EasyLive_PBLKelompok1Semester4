import 'package:flutter/material.dart';
import '../../controllers/booking_controller.dart';
import '../../core/color.dart';
import '../../widgets/booking/booking_card.dart';
import '../../widgets/booking/booking_empty_state.dart';
import '../../widgets/booking/booking_filter_chip.dart';
import '../../widgets/home/bottom_navbar.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(
          length: BookingController.bookingStatuses.length,
          vsync: this,
        )..addListener(() {
          if (_tabController.indexIsChanging) {
            setState(() {});
          }
        });
  }

  String get _currentStatus =>
      BookingController.bookingStatuses[_tabController.index];

  Widget _buildTabContent() {
    final bookings = BookingController.getFilteredBookings(_currentStatus);
    final emptyMessage = BookingController.getEmptyMessage(_currentStatus);

    if (bookings.isEmpty) {
      return BookingEmptyState(message: emptyMessage, compactTopSpacing: true);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookings
            .map((booking) => BookingCard(booking: booking))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.crop_free_rounded,
                    color: AppColors.yellow,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Booking',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: AppColors.yellow,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.yellow,
                    size: 26,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  BookingFilterChip(
                    label: 'Kost',
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  BookingFilterChip(
                    label: 'Jasa',
                    isSelected: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Expanded(child: _buildTabContent()),
            const BottomNav(currentIndex: 2),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
