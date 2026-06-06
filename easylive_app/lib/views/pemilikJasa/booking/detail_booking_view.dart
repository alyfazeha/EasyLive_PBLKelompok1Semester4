import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikJasa/booking/detail_booking_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class DetailBookingView extends StatefulWidget {
  final String idBooking;

  const DetailBookingView({super.key, required this.idBooking});

  @override
  State<DetailBookingView> createState() => _DetailBookingViewState();
}

class _DetailBookingViewState extends State<DetailBookingView> {
  late DetailBookingJasaController controller;

  @override
  void initState() {
    super.initState();
    controller = DetailBookingJasaController(idBooking: widget.idBooking);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
    }
  }

  Future<void> _showTolakDialog() async {
    final alasanController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Alasan Penolakan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            color: AppColors.darkBlue,
          ),
        ),
        content: TextField(
          controller: alasanController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan alasan penolakan...',
            hintStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              final alasan = alasanController.text.trim();
              if (alasan.isEmpty) return;
              Navigator.pop(ctx);
              await controller.tolak(context, alasan);
            },
            child: const Text(
              'Tolak',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 30,
                  20,
                  20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _goBack,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(10),
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
                        'Detail Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CONTENT
              Expanded(
                child: Consumer<DetailBookingJasaController>(
                  builder: (context, ctrl, _) {
                    if (ctrl.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (ctrl.booking == null) {
                      return const Center(child: Text('Gagal memuat data'));
                    }

                    final booking = ctrl.booking!;
                    final isPending = booking.bookingStatus == 'Pending';
                    final isAktif = booking.bookingStatus == 'Aktif';
                    final isLunas = booking.paymentStatus == 'Lunas';

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER PENYEWA
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: AppColors.lightGrey,
                                      child: Text(
                                        booking.tenantName.isNotEmpty
                                            ? booking.tenantName[0]
                                            : 'A',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkBlue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.tenantName,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkBlue,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone,
                                                  size: 14,
                                                  color: Colors.black54),
                                              const SizedBox(width: 6),
                                              Text(
                                                booking.phone,
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.email_outlined,
                                                  size: 14,
                                                  color: Colors.black54),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  booking.email,
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    _StatusBadge(label: booking.bookingStatus),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // INFO DETAIL
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildDetailRow('Jasa', booking.jasaName),
                                      const SizedBox(height: 12),
                                      _buildDetailRow('Penjemputan',
                                          booking.titikPenjemputan),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                          'Tujuan', booking.titikTujuan),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                          'Tanggal', booking.tanggal),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                          'Total Bayar', booking.totalBayar),
                                      const SizedBox(height: 12),
                                      _buildDetailRow(
                                        'Status Pembayaran',
                                        booking.paymentStatus,
                                        badge: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ALASAN PENOLAKAN
                          if (booking.bookingStatus == 'Ditolak' &&
                              booking.alasanPenolakan.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Alasan Penolakan',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    booking.alasanPenolakan,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // TOMBOL AKSI - PENDING
                          if (isPending) ...[
                            const SizedBox(height: 24),
                            if (isLunas)
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF31B75D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => ctrl.konfirmasi(context),
                                  child: const Text(
                                    'Konfirmasi Booking',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _showTolakDialog,
                                child: const Text(
                                  'Tolak Booking',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // TOMBOL AKSI - AKTIF
                          if (isAktif) ...[
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4D82FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => ctrl.selesai(context),
                                child: const Text(
                                  'Tandai Selesai',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom),
          child: PemilikJasaBottomNav(
            currentIndex: 3,
            onNavigate: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(
                    context, '/pemilik_jasa/dashboard');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
              } else if (index == 3) {
                Navigator.pushReplacementNamed(
                    context, '/pemilik_jasa/booking');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool badge = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
        badge
            ? Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: value == 'Lunas'
                      ? const Color(0xFFD9F4DF)
                      : const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: value == 'Lunas'
                        ? const Color(0xFF31B75D)
                        : const Color(0xFFFFB200),
                  ),
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (label.toLowerCase()) {
      case 'aktif':
        bgColor = const Color(0xFFD9F4DF);
        textColor = const Color(0xFF31B75D);
        break;
      case 'pending':
        bgColor = const Color(0xFFFFF3D6);
        textColor = const Color(0xFFFFB200);
        break;
      case 'ditolak':
        bgColor = const Color(0xFFFFEAEA);
        textColor = Colors.red;
        break;
      case 'selesai':
        bgColor = const Color(0xFFEAF1FF);
        textColor = const Color(0xFF4D82FF);
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}