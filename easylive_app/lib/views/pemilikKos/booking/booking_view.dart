import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikKos/booking_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikKos/booking/booking_card.dart';
import '../../../widgets/pemilikKos/booking/searching.dart';
import '../../../widgets/pemilikKos/booking/filtering.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';

class OwnerBookingView extends StatefulWidget {
  const OwnerBookingView({super.key});

  @override
  State<OwnerBookingView> createState() => _OwnerBookingViewState();
}

class _OwnerBookingViewState extends State<OwnerBookingView> {
  late BookingController controller;

  @override
  void initState() {
    super.initState();
    controller = BookingController(); // fresh tiap buka page
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              /// HEADER — tidak diubah
              Container(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                decoration: const BoxDecoration(color: AppColors.darkBlue),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/pemilik_kos');
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Booking",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              /// CONTENT
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Consumer<BookingController>(
                    builder: (context, ctrl, _) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
                            child: Column(
                              children: [
                                /// SEARCH
                                SearchBarWidget(
                                  onChanged: (value) => ctrl.setSearch(value),
                                ),

                                const SizedBox(height: 12),

                                /// FILTER
                                BookingFilter(
                                  selectedFilter: ctrl.selectedFilter,
                                  onChanged: (value) => ctrl.setFilter(value),
                                ),

                                const SizedBox(height: 14),
                              ],
                            ),
                          ),

                          /// LIST
                          Expanded(
                            child: ctrl.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : ctrl.filteredList.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Belum ada booking',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.black45,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        itemCount: ctrl.filteredList.length,
                                        itemBuilder: (context, index) {
                                          return BookingCard(
                                            booking: ctrl.filteredList[index],
                                          );
                                        },
                                      ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: OwnerBottomNav(
          currentIndex: 3,
          onNavigate: _navigateTo,
        ),
      ),
    );
  }
}