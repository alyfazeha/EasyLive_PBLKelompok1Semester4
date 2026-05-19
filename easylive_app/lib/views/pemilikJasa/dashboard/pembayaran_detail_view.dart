import 'package:flutter/material.dart';

import '../../../controllers/pemilikJasa/payment_detail_controller.dart';
import '../../../core/color.dart';
import '../../../models/pemilikJasa/dashboard_model.dart';
import '../../../widgets/pemilikJasa/dashboard/payment_detail_widgets.dart';

class PemilikJasaPembayaranDetailView extends StatelessWidget {
  const PemilikJasaPembayaranDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;

    // Support kiriman dari list card (JasaPaymentHistory) atau Map.
    JasaPaymentHistory toHistory(Object? input) {
      if (input is JasaPaymentHistory) return input;

      if (input is Map<String, dynamic>) {
        String readString(
          Map<String, dynamic> map,
          String key, [
          String fallback = '-',
        ]) {
          final value = map[key];
          if (value == null) return fallback;
          return value.toString();
        }

        int readInt(Map<String, dynamic> map, String key) {
          final value = map[key];
          if (value is int) return value;
          if (value is num) return value.toInt();
          return int.tryParse(value?.toString() ?? '') ?? 0;
        }

        return JasaPaymentHistory(
          name: readString(input, 'name'),
          vehicleType: readString(input, 'vehicleType'),
          location: readString(input, 'location'),
          date: readString(input, 'date'),
          price: readString(input, 'price'),
          status: readString(input, 'status'),
          paymentMethod: readString(input, 'paymentMethod'),
          transactionId: readString(input, 'transactionId'),
          totalPayment: readInt(input, 'totalPayment'),
        );
      }

      const fallback = JasaPaymentHistory(
        name: '-',
        vehicleType: '-',
        location: '-',
        date: '-',
        price: '-',
        status: '-',
        paymentMethod: '-',
        transactionId: '-',
        totalPayment: 0,
      );
      return fallback;
    }

    final history = toHistory(arg);
    final controller = PaymentDetailController();
    final detail = controller.getPaymentDetail(history: history);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          // Header (disamakan seperti Pemilik Kos)
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentInfoCard(
                    payment: detail,
                    formattedTotal: controller.formatCurrency(
                      detail.totalPayment,
                    ),
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
                  PaymentStatusCard(payment: detail),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
