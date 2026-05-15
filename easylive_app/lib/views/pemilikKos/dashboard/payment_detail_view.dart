import 'package:flutter/material.dart';
import '../../../controllers/pemilikKos/payment_detail_controller.dart';
import '../../../core/color.dart';
import '../../../models/pemilikKos/dashboard_model.dart';
import '../../../widgets/pemilikKos/dashboard/payment_detail_widgets.dart';

class PaymentDetailView extends StatelessWidget {
  final Dashboard dashboard; // ← tambah parameter

  PaymentDetailView({super.key, required this.dashboard}); // ← tambah required

  @override
  Widget build(BuildContext context) {
    final controller = PaymentDetailController(dashboard: dashboard); // ← pass dashboard
    final payment = controller.getPaymentDetail();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          // Header — tidak diubah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Detail Pembayaran',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),

          // Content — tidak diubah
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentInfoCard(
                    payment: payment,
                    formattedTotal: controller.formatCurrency(payment.totalPayment),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Rincian Pembayaran',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PaymentSummaryCard(
                    payment: payment,
                    formatCurrency: controller.formatCurrency,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Riwayat Status',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PaymentStatusCard(payment: payment),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bukti pembayaran berhasil diunduh'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, color: AppColors.darkBlue),
                      label: const Text(
                        'Unduh Bukti Pembayaran',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.darkBlue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}