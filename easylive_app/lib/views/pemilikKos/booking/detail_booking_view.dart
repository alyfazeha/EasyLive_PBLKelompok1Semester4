import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikKos/detail_booking_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/pemilikKos/booking/detail_booking_widgets.dart';
import '../../../widgets/pemilikKos/home/bottom_navbar.dart';

class DetailBookingView extends StatefulWidget {
  final String idBooking;

  const DetailBookingView({
    super.key,
    required this.idBooking,
  });

  @override
  State<DetailBookingView> createState() => _DetailBookingViewState();
}

class _DetailBookingViewState extends State<DetailBookingView> {
  late DetailBookingController controller;

  @override
  void initState() {
    super.initState();
    controller = DetailBookingController(idBooking: widget.idBooking);
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
      Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
    }
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/dashboard');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/pemilik_kos/history');
    }
  }

  // Dialog input alasan penolakan
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
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
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
        backgroundColor: AppColors.darkBlue,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    InkWell(
                      onTap: _goBack,
                      borderRadius: BorderRadius.circular(18),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Detail Penyewa',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
                  child: Consumer<DetailBookingController>(
                    builder: (context, ctrl, _) {
                      if (ctrl.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (ctrl.booking == null) {
                        return const Center(
                          child: Text('Gagal memuat data'),
                        );
                      }

                      final booking = ctrl.booking!;
                      final isPending = booking.bookingStatus == 'Pending';
                      final isLunas = booking.paymentStatus == 'Lunas';

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                        child: Column(
                          children: [
                            DetailBookingTenantHeader(booking: booking),
                            const SizedBox(height: 28),
                            DetailBookingInfoCard(booking: booking),

                            // Tampilkan alasan penolakan jika ditolak
                            if (booking.bookingStatus == 'Ditolak' &&
                                booking.alasanPenolakan.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
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

                            // Tombol konfirmasi & tolak (hanya jika pending)
                            if (isPending) ...[
                              const SizedBox(height: 24),

                              // Tombol Konfirmasi — hanya muncul jika sudah Lunas
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
                                    onPressed: () =>
                                        ctrl.konfirmasi(context),
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

                              // Tombol Tolak — selalu muncul jika pending
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: OwnerBottomNav(
            currentIndex: 3,
            onNavigate: _navigateTo,
          ),
        ),
      ),
    );
  }
}