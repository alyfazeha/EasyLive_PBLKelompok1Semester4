import 'package:flutter/material.dart';

import '../../../models/pemilikKos/notifikasi_detail_model.dart';
import '../../../models/pemilikKos/notifikasi_model.dart';

class DetailInfoCard extends StatelessWidget {
  final NotificationModel data;
  final OwnerNotificationType type;

  const DetailInfoCard({super.key, required this.data, required this.type});

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2F4157),
              ),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          if (type == OwnerNotificationType.approved)
            buildRow('Jasa', data.property),

          if (type == OwnerNotificationType.rejected)
            buildRow('Jasa', data.property),

          if (type == OwnerNotificationType.booking) ...[
            buildRow('Jasa', data.property),
            buildRow('Tanggal Check-in', data.checkIn),
          ],

          if (type == OwnerNotificationType.payment) ...[
            buildRow('Jasa', data.property),
            buildRow('Tanggal Bayar', data.checkIn),
            buildRow('Metode Pembayaran', data.paymentMethod),
          ],
        ],
      ),
    );
  }
}
