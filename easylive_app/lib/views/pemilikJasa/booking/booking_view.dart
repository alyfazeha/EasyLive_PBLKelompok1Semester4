import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/booking/booking_controller.dart';
import '../../../core/color.dart';
import '../../../models/pemilikJasa/booking_model.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class PemilikJasaBookingView extends StatefulWidget {
  const PemilikJasaBookingView({super.key});

  @override
  State<PemilikJasaBookingView> createState() => _PemilikJasaBookingViewState();
}

class _PemilikJasaBookingViewState extends State<PemilikJasaBookingView> {
  final TextEditingController _searchController = TextEditingController();

  late OwnerJasaBookingController _bookingController;

  @override
  void initState() {
    super.initState();
    _bookingController = OwnerJasaBookingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearch(String value) {
    _bookingController.setSearch(value);
  }

  Widget _filterChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final Color textColor = active ? AppColors.darkBlue : Colors.white;

    final Color bgColor = active ? Colors.white : AppColors.darkBlue;

    final Color borderColor = active
        ? AppColors.darkBlue
        : Colors.grey.shade300;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    String statusText = 'ACTIVE';
    Color statusBgColor = AppColors.yellow;

    switch (booking.status) {
      case 'pending':
        statusText = 'Pending';
        statusBgColor = AppColors.yellow;
        break;

      case 'aktif':
        statusText = 'Aktif';
        statusBgColor = const Color(0xFF31B75D);
        break;

      case 'selesai':
        statusText = 'Selesai';
        statusBgColor = Colors.grey.shade400;
        break;

      default:
        statusText = booking.status;
        statusBgColor = AppColors.yellow;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                booking.profileImage != null && booking.profileImage!.isNotEmpty
                ? NetworkImage(booking.profileImage!)
                : null,
            backgroundColor: AppColors.lightGrey,
            onBackgroundImageError: (exception, stackTrace) {},
            child: booking.profileImage == null || booking.profileImage!.isEmpty
                ? const Icon(Icons.person, size: 18, color: AppColors.darkBlue)
                : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.nama,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  '${booking.tanggal} • ${booking.jam}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: statusText.toLowerCase().contains('pending')
                    ? AppColors.darkBlue
                    : Colors.white,
              ),
            ),
          ),
        ],
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
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          '/pemilik_jasa',
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.darkBlue,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Expanded(
                    child: Text(
                      'Booking',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // SEARCH
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: _updateSearch,
                                    decoration: const InputDecoration(
                                      hintText: 'Cari Penyewaan...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // FILTER CHIP
                          AnimatedBuilder(
                            animation: _bookingController,
                            builder: (context, _) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    _filterChip(
                                      label: 'All',
                                      active:
                                          _bookingController.selectedFilter ==
                                          'semua',
                                      onTap: () {
                                        _bookingController.setFilter('semua');
                                      },
                                    ),

                                    const SizedBox(width: 35),

                                    _filterChip(
                                      label: 'Pending',
                                      active:
                                          _bookingController.selectedFilter ==
                                          'pending',
                                      onTap: () {
                                        _bookingController.setFilter('pending');
                                      },
                                    ),

                                    const SizedBox(width: 35),

                                    _filterChip(
                                      label: 'Aktif',
                                      active:
                                          _bookingController.selectedFilter ==
                                          'aktif',
                                      onTap: () {
                                        _bookingController.setFilter('aktif');
                                      },
                                    ),

                                    const SizedBox(width: 35),

                                    _filterChip(
                                      label: 'Selesai',
                                      active:
                                          _bookingController.selectedFilter ==
                                          'selesai',
                                      onTap: () {
                                        _bookingController.setFilter('selesai');
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // BOOKING LIST
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: AnimatedBuilder(
                          animation: _bookingController,
                          builder: (context, _) {
                            final list = _bookingController.filteredList;

                            if (list.isEmpty) {
                              return Center(
                                child: Text(
                                  'Tidak ada booking',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                100,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final booking = list[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/pemilik_jasa/detail_booking',
                                      arguments: booking.nama,
                                    );
                                  },
                                  child: _buildBookingCard(booking),
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
          ],
        ),
      ),

      bottomNavigationBar: PemilikJasaBottomNav(
        currentIndex: 3,
        onNavigate: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
          }
        },
      ),
    );
  }
}
