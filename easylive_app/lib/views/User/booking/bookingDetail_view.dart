import 'package:flutter/material.dart';
import '../../../models/booking_model.dart'; // Import model kamu
import '../../../core/color.dart';

class BookingDetailView extends StatelessWidget {
  final Booking booking; // 1. Tambahkan variabel ini

  // 2. Buat constructor agar parameter 'booking' tidak error
  const BookingDetailView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Biru Tua sesuai mockup
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.golden,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.darkBlue,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Detail Booking',
                    style: TextStyle(
                      color: AppColors.golden,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kartu Detail (Persis Mockup Gambar 3 & 4)
          Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.darkBlue),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfo('Customer', 'Ahmad Rafi Hamdi'),
                            _buildInfo(
                              'Order',
                              booking.title,
                            ), // Menggunakan data booking
                            _buildInfo('Date', '09:00, Tuesday, 21 April 2026'),

                            const Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            // Badge Sukses Kuning sesuai mockup
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.golden,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                'Success',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Aksen Biru Tua di sisi kanan
                    Container(
                      width: 15,
                      decoration: const BoxDecoration(
                        color: AppColors.darkBlue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Expanded(child: Divider(color: AppColors.darkBlue)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 15),
      ],
    );
  }
}
