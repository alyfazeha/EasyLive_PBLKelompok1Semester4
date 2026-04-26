import 'package:flutter/material.dart';

import '../../controllers/booking_controller.dart';
import '../../core/color.dart';
import '../../widgets/booking/booking_card.dart';
<<<<<<< HEAD
import '../../widgets/booking/booking_empty_state.dart';
=======
<<<<<<< Updated upstream
>>>>>>> ailsa
import '../../widgets/home/botton_navbar.dart';
=======
import '../../widgets/booking/booking_empty_state.dart';
import '../../widgets/booking/booking_filter_chip.dart';
import '../../widgets/home/bottom_navbar.dart';
>>>>>>> Stashed changes

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

<<<<<<< HEAD
  Widget _buildTabContent() {
    final bookings = _controller.getFilteredBookings(_currentStatus);
    final emptyMessage = _controller.getEmptyMessage(_currentStatus);

    if (bookings.isEmpty) {
      return BookingEmptyState(message: emptyMessage);
=======
<<<<<<< Updated upstream
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const _EmptyPaperIllustration(),
            const SizedBox(height: 44),
            Text(
              "You have no ${status.toLowerCase()} booking",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.title1,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      );
>>>>>>> ailsa
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
<<<<<<< HEAD
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookings.map((booking) => BookingCard(booking: booking)).toList(),
      ),
=======
      itemCount: list.length,
      itemBuilder: (context, index) => BookingCard(booking: list[index]),
=======
  Widget _buildTabContent() {
    final bookings = _controller.getFilteredBookings(_currentStatus);
    final emptyMessage = _controller.getEmptyMessage(_currentStatus);

    if (bookings.isEmpty) {
      return BookingEmptyState(
        message: emptyMessage,
        compactTopSpacing: true,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bookings
            .map((booking) => BookingCard(booking: booking))
            .toList(),
      ),
>>>>>>> Stashed changes
>>>>>>> ailsa
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
<<<<<<< Updated upstream
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
=======
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
                      'History',
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
>>>>>>> Stashed changes
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 1,
                    color: AppColors.title1.withValues(alpha: 0.55),
                  ),
                ],
              ),
            ),
<<<<<<< HEAD
            Expanded(child: _buildTabContent()),
=======
<<<<<<< Updated upstream
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent("Active"),
                  _buildTabContent("Completed"),
                  _buildTabContent("Canceled"),
                ],
              ),
            ),
=======

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

            Expanded(
              child: _buildTabContent(),
            ),
>>>>>>> Stashed changes
>>>>>>> ailsa
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
