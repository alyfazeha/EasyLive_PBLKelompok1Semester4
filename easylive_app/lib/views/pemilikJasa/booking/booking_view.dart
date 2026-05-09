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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/pemilik_jasa');
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
                  const SizedBox(width: 12),
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
            // Search and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _updateSearch,
                        decoration: const InputDecoration(
                          hintText: 'Cari Pernyewaan...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.darkBlue,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            // Booking List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: _bookingController.filteredList.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada booking',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: _bookingController.filteredList.length,
                        itemBuilder: (context, index) {
                          final booking = _bookingController.filteredList[index];
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
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/pemilik_jasa/home');
          }
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    String statusText = 'ACTIVE';
    Color statusBgColor = AppColors.yellow;

    switch (booking.status) {
      case 'aktif':
        statusText = 'ACTIVE';
        statusBgColor = const Color(0xFF31B75D);
        break;
      case 'pending':
        statusText = 'WAITING';
        statusBgColor = AppColors.yellow;
        break;
      case 'selesai':
        statusText = 'NEXT';
        statusBgColor = Colors.grey.shade400;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(booking.profileImage ?? ''),
            onBackgroundImageError: (exception, stackTrace) {
              // Fallback if image fails to load
            },
          ),
          const SizedBox(width: 12),
          // Name and Details
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${booking.tanggal} • ${booking.jam}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: booking.status == 'pending'
                    ? AppColors.darkBlue
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
