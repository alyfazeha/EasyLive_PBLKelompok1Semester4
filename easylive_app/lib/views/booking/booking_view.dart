import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../controllers/booking_controller.dart';
import '../../widgets/booking/booking_card.dart';
<<<<<<< Updated upstream
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
  late TabController _tabController;
  final BookingController _controller = BookingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildTabContent(String status) {
    final list = _controller.getFilteredBookings(status);

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
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 24),
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
              padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.crop_free_rounded, color: AppColors.title1, size: 28),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "My Bookings",
                          style: TextStyle(
                            color: AppColors.titleName,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Icon(Icons.search_rounded, color: AppColors.title1, size: 32),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      dividerColor: AppColors.title1.withValues(alpha: 0.35),
                      indicator: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.title1,
                      unselectedLabelColor: AppColors.titleName,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      tabs: const [
                        Tab(text: "Active Now"),
                        Tab(text: "Completed"),
                        Tab(text: "Canceled"),
                      ],
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
                ],
              ),
            ),
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

class _EmptyPaperIllustration extends StatelessWidget {
  const _EmptyPaperIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 250,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.12,
            child: Transform.translate(
              offset: const Offset(-14, 18),
              child: Container(
                width: 138,
                height: 168,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F2EC),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.1,
            child: Transform.translate(
              offset: const Offset(18, 10),
              child: Container(
                width: 145,
                height: 178,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0EA),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE7E0D6)),
                ),
              ),
            ),
          ),
          Container(
            width: 156,
            height: 188,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  offset: Offset(0, 5),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          const Positioned(
            top: 16,
            left: 36,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-0.12),
              child: Icon(
                Icons.attach_file_rounded,
                size: 52,
                color: Color(0xFFD1A8A3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
