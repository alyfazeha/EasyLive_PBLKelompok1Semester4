import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/pemilikJasa/payment_detail_controller.dart';
import '../../../core/color.dart';
import '../../../models/pemilikJasa/dashboard_model.dart';
import '../../../widgets/pemilikJasa/dashboard/payment_detail_widgets.dart';

class PemilikJasaPembayaranDetailView extends StatefulWidget {
  const PemilikJasaPembayaranDetailView({super.key});

  @override
  State<PemilikJasaPembayaranDetailView> createState() =>
      _PemilikJasaPembayaranDetailViewState();
}

class _PemilikJasaPembayaranDetailViewState
    extends State<PemilikJasaPembayaranDetailView> {
  late PaymentDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = PaymentDetailController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;

    // Load dari Supabase jika arg adalah JasaPaymentHistory
    if (arg is JasaPaymentHistory && controller.detail == null && !controller.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadFromSupabase(arg.idPayment);
      });
    }

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<PaymentDetailController>(
        builder: (context, ctrl, _) {
          // Fallback ke data dari argument jika Supabase belum load
          final detail = ctrl.detail ??
              (arg is JasaPaymentHistory
                  ? ctrl.getPaymentDetail(history: arg)
                  : null);

          return Scaffold(
            backgroundColor: const Color(0xFFF7F8FA),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
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
                Expanded(
                  child: ctrl.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : detail == null
                          ? const Center(child: Text('Gagal memuat data'))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PaymentInfoCard(
                                    payment: detail,
                                    formattedTotal:
                                        ctrl.formatCurrency(detail.totalPayment),
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
                                    payment: detail,
                                    formatCurrency: ctrl.formatCurrency,
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
                                  PaymentStatusCard(payment: detail),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}