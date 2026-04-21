import 'package:flutter/material.dart';

import '../../controllers/booking_controller.dart';
import '../../core/color.dart';
import '../../widgets/booking/booking_card.dart';
import '../../widgets/booking/booking_empty_state.dart';
import '../../widgets/home/botton_navbar.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final BookingController _controller = BookingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
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
    final bookings = _controller.getFilteredBookings(_currentStatus);
    final emptyMessage = _controller.getEmptyMessage(_currentStatus);

    if (bookings.isEmpty) {
      return BookingEmptyState(message: emptyMessage);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookings.map((booking) => BookingCard(booking: booking)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.crop_free_rounded,
                        color: AppColors.title1,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'My Bookings',
                          style: TextStyle(
                            color: AppColors.titleName,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
                        color: AppColors.title1,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 34,
                    child: Row(
                      children: BookingController.bookingStatuses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final status = entry.value;
                        final isActive = _currentStatus == status;
                        final label = switch (status) {
                          'Active' => 'Active Now',
                          'Completed' => 'Completed',
                          _ => 'Canceled',
                        };

                        return Expanded(
                          child: Align(
                            alignment: index == 0
                                ? Alignment.centerLeft
                                : index == BookingController.bookingStatuses.length - 1
                                ? Alignment.centerRight
                                : Alignment.center,
                            child: InkWell(
                              onTap: () {
                                _tabController.animateTo(index);
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive ? AppColors.card : Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: AppColors.title1,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 1,
                    color: AppColors.title1.withValues(alpha: 0.55),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
