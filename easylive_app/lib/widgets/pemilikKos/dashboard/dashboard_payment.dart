import 'package:flutter/material.dart';
import '../../../core/color.dart';

class PaymentHistoryCard extends StatelessWidget {
  final String name;
  final String kost;
  final String date;
  final String price;
  final String status;

  const PaymentHistoryCard({
    super.key,
    required this.name,
    required this.kost,
    required this.date,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ROW ATAS
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// NAMA KOST
          Text(
            kost,
           style: TextStyle(
             fontFamily: 'Montserrat',
             fontSize: 12,
             fontWeight: FontWeight.w700,
             color: AppColors.darkBlue,
                        ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
              ),
              const Spacer(),

              /// STATUS BADGE
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Lunas",
                 style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBlue,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}