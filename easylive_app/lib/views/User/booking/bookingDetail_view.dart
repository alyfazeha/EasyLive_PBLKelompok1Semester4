import 'package:flutter/material.dart';
import '../../../models/user/booking_model.dart';
import '../../../core/color.dart';

class BookingDetailView extends StatelessWidget {
  final Booking booking;
  const BookingDetailView({super.key, required this.booking});

  Color _statusColor(String? raw) {
    switch (raw) {
      case 'dikonfirmasi':
        return Colors.green;
      case 'menunggu':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      case 'selesai':
        return Colors.blue;
      default:
        return AppColors.golden;
    }
  }

  String _statusLabel(String? raw) {
    switch (raw) {
      case 'dikonfirmasi':
        return 'Dikonfirmasi';
      case 'menunggu':
        return 'Menunggu';
      case 'ditolak':
        return 'Ditolak';
      case 'selesai':
        return 'Selesai';
      default:
        return booking.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDitolak = booking.rawStatus == 'ditolak';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Kartu Detail
                  Container(
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
                                  _buildInfo('Tipe', booking.type),
                                  _buildInfo('Order', booking.title),
                                  _buildInfo('Lokasi', booking.location),
                                  _buildInfo('Tanggal', booking.date),
                                  _buildInfo('Total', booking.price),

                                  const Text(
                                    'Status',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(  // ← wrap dengan Flexible
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,  // ← kurangi dari 20
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(booking.rawStatus),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        _statusLabel(booking.rawStatus),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4), // ← tambah sedikit padding bawah
                                ],
                              ),
                            ),
                          ),
                          // Aksen kanan
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

                  // Box Alasan Penolakan — hanya muncul jika ditolak
                  if (isDitolak) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red.shade300, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cancel_outlined, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Alasan Penolakan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            (booking.alasanPenolakan?.isNotEmpty == true)
                                ? booking.alasanPenolakan!
                                : 'Tidak ada keterangan dari pemilik.',
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
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