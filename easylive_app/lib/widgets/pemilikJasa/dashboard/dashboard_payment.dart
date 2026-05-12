import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikJasa/dashboard_model.dart';

class JasaPaymentHistoryCard extends StatelessWidget {
  final JasaPaymentHistory payment;

  const JasaPaymentHistoryCard({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/pemilik_jasa/dashboard/detail_pembayaran',
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${payment.name} (${payment.vehicleType})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                payment.price,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            payment.location,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                payment.date,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6EC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  payment.status,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF31B75D),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
