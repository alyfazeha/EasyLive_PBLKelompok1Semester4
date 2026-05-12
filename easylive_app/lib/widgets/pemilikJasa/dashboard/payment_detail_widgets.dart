import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikJasa/payment_detail_model.dart';

class PaymentInfoCard extends StatelessWidget {
  final JasaPaymentDetailModel payment;
  final String formattedTotal;

  const PaymentInfoCard({
    super.key,
    required this.payment,
    required this.formattedTotal,
  });

  Widget buildInfoItem(
    IconData icon,
    Color iconColor,
    String title,
    String value,
  ) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE7ECF3),
                child: Icon(Icons.person, size: 34, color: Colors.grey),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${payment.ownerName} (${payment.vehicleType})',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.location,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  payment.status,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: payment.status.toLowerCase() == 'lunas'
                        ? const Color(0xFF22A95A)
                        : AppColors.darkBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 20),
          Row(
            children: [
              buildInfoItem(
                Icons.calendar_month,
                Colors.blue,
                'Tanggal Pembayaran',
                payment.paymentDate,
              ),
              const SizedBox(width: 14),
              buildInfoItem(
                Icons.attach_money,
                Colors.pink,
                'Total Pembayaran',
                formattedTotal,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              buildInfoItem(
                Icons.credit_card,
                Colors.amber,
                'Metode Pembayaran',
                payment.paymentMethod,
              ),
              const SizedBox(width: 14),
              buildInfoItem(
                Icons.receipt_long,
                Colors.green,
                'No. Transaksi',
                payment.transactionId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSummaryCard extends StatelessWidget {
  final JasaPaymentDetailModel payment;
  final String Function(int) formatCurrency;

  const PaymentSummaryCard({
    super.key,
    required this.payment,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          ...payment.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  Text(
                    formatCurrency(item.amount),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                formatCurrency(payment.totalPayment),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentStatusCard extends StatelessWidget {
  final JasaPaymentDetailModel payment;

  const PaymentStatusCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isLunas = payment.status.toLowerCase() == 'lunas';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isLunas ? const Color(0xFF22C55E) : AppColors.darkBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLunas ? Icons.check : Icons.info,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLunas ? 'Pembayaran Lunas' : 'Pembayaran Belum Lunas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${payment.paymentDate} • 10:30 WIB',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EE),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              payment.status,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: isLunas ? const Color(0xFF22A95A) : AppColors.darkBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
