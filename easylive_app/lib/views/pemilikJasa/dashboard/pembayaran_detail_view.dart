import 'package:flutter/material.dart';

import '../../../models/pemilikJasa/dashboard_model.dart';
import '../../../core/color.dart';

class PemilikJasaPembayaranDetailView extends StatelessWidget {
  const PemilikJasaPembayaranDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final payment = ModalRoute.of(context)?.settings.arguments;

    String readString(Map<String, dynamic> map, String key, [String fallback = '-']) {
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

    final JasaPaymentHistory data = payment is JasaPaymentHistory
        ? payment
        : (payment is Map<String, dynamic>
              ? JasaPaymentHistory(
                  name: readString(payment, 'name'),
                  vehicleType: readString(payment, 'vehicleType'),
                  location: readString(payment, 'location'),
                  date: readString(payment, 'date'),
                  price: readString(payment, 'price'),
                  status: readString(payment, 'status'),
                  paymentMethod: readString(payment, 'paymentMethod'),
                  transactionId: readString(payment, 'transactionId'),
                  totalPayment: readInt(payment, 'totalPayment'),
                )
              : const JasaPaymentHistory(
                  name: '-',
                  vehicleType: '-',
                  location: '-',
                  date: '-',
                  price: '-',
                  status: '-',
                  paymentMethod: '-',
                  transactionId: '-',
                  totalPayment: 0,
                ));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.primary,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Detail Pembayaran',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoTitle('Penyewa / Customer'),
                    _InfoValue(data.name),
                    const SizedBox(height: 12),

                    _InfoTitle('Kendaraan'),
                    _InfoValue(data.vehicleType),
                    const SizedBox(height: 12),

                    _InfoTitle('Lokasi'),
                    _InfoValue(data.location),
                    const SizedBox(height: 12),

                    _InfoTitle('Tanggal'),
                    _InfoValue(data.date),
                    const SizedBox(height: 12),

                    _InfoTitle('Total'),
                    _InfoValue(data.price),
                    const SizedBox(height: 12),

                    _InfoTitle('Status'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F6EC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF31B75D).withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        data.status,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF31B75D),
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
    );
  }
}

class _InfoTitle extends StatelessWidget {
  final String title;

  const _InfoTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.black54,
      ),
    );
  }
}

class _InfoValue extends StatelessWidget {
  final String value;

  const _InfoValue(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}
