import 'package:flutter/material.dart';
import '../../../core/color.dart';

class PaymentResultView extends StatelessWidget {
  final String resultCode;
  final String reference;
  final int? idBookingKost;
  final int? idBookingJasa;

  const PaymentResultView({
    super.key,
    required this.resultCode,
    required this.reference,
    this.idBookingKost,
    this.idBookingJasa,
  });

  // resultCode dari Duitku redirect:
  // "00" = berhasil, "01" = pending/proses, "02" = gagal/batal
  bool get _isSuccess => resultCode == '00';
  bool get _isPending => resultCode == '01';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon status
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isSuccess
                      ? Colors.green.shade50
                      : _isPending
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                ),
                child: Icon(
                  _isSuccess
                      ? Icons.check_circle_rounded
                      : _isPending
                          ? Icons.hourglass_top_rounded
                          : Icons.cancel_rounded,
                  size: 80,
                  color: _isSuccess
                      ? Colors.green
                      : _isPending
                          ? Colors.orange
                          : Colors.red,
                ),
              ),

              const SizedBox(height: 30),

              // Judul
              Text(
                _isSuccess
                    ? 'Pembayaran Berhasil!'
                    : _isPending
                        ? 'Pembayaran Diproses'
                        : 'Pembayaran Gagal',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Deskripsi
              Text(
                _isSuccess
                    ? 'Booking kos kamu telah dikonfirmasi. Cek halaman booking untuk detail.'
                    : _isPending
                        ? 'Pembayaran sedang diverifikasi. Kami akan memberitahu kamu segera.'
                        : 'Pembayaran tidak berhasil. Silakan coba lagi.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Reference number
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Nomor Referensi',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reference,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol kembali ke home
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman utama, hapus semua route sebelumnya
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home', // sesuaikan dengan route home kamu
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              // Tombol lihat booking (hanya jika sukses/pending)
              if (_isSuccess || _isPending) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/booking', // sesuaikan dengan route booking kamu
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Lihat Booking Saya',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}