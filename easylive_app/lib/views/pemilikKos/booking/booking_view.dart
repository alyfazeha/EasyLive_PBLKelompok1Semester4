import 'package:flutter/material.dart';
import '../../../core/color.dart';
import '../../../models/pemilikKos/booking_model.dart';
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
  List<Booking> allBookings = [
    Booking(
      nama: "Budi Santoso",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Pending",
    ),
    Booking(
      nama: "Andi Wijaya",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Aktif",
    ),
    Booking(
      nama: "Siti Aminah",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Aktif",
    ),
    Booking(
      nama: "Rudi Hartono",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Aktif",
    ),
    Booking(
      nama: "Dwi Lestari",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Aktif",
    ),
    Booking(
      nama: "Ahmad Fauzi",
      kamar: "Kamar 01 - Daniska Kost",
      status: "Selesai",
    ),
  ];

  List<Booking> filtered = [];

  String selectedFilter = "All";
  String searchText = "";

  @override
  void initState() {
    super.initState();
    filtered = allBookings;
  }

  void applyFilter() {
    setState(() {
      filtered = allBookings.where((b) {
        final matchSearch = b.nama.toLowerCase().contains(
          searchText.toLowerCase(),
        );

        final matchFilter = selectedFilter == "All"
            ? true
            : b.status.toLowerCase() == selectedFilter.toLowerCase();

        return matchSearch && matchFilter;
      }).toList();
    });
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos');
    } else if (index == 3) {
      // already on bookings page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔵 HEADER
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

            /// 🔻 CONTENT
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// 🔍 SEARCH
                        SearchBarWidget(
                          onChanged: (value) {
                            searchText = value;
                            applyFilter();
                          },
                        ),

                        const SizedBox(height: 12),

                        /// 🔘 FILTER
                        BookingFilter(
                          selectedFilter: selectedFilter,
                          onChanged: (value) {
                            selectedFilter = value;
                            applyFilter();
                          },
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  ),

                  /// 📋 LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return BookingCard(booking: filtered[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNav(
        currentIndex: 3,
        onNavigate: _navigateTo,
      ),
    );
  }
}
