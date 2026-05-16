import 'package:flutter/material.dart';

import '../../../models/admin/history_detail_model.dart';

class HistoryDetailInfoCard extends StatelessWidget {
  final AdminHistoryDetailModel data;

  const HistoryDetailInfoCard({super.key, required this.data});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Pihak', data.pihak),
          _row('Kategori', data.kategori),
          _row('Objek', data.objek),
          _row('Status', data.status),
          if (data.alasanPenolakan != null) ...[
            const SizedBox(height: 6),
            _row('Alasan Penolakan', data.alasanPenolakan!),
          ],
        ],
      ),
    );
  }
}
