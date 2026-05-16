import 'package:flutter/material.dart';

import '../../../models/admin/notifikasi/notifikasi_model.dart';

class AdminNotificationDetailInfoCard extends StatelessWidget {
  final AdminNotificationDetail detail;

  const AdminNotificationDetailInfoCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Notifikasi',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF243447),
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            label: detail.primaryInfoLabel,
            value: detail.primaryInfoValue,
          ),
          ...detail.rows.map(
            (row) => _InfoRow(label: row.label, value: row.value),
          ),
          const SizedBox(height: 8),
          const Divider(height: 18),
          const Text(
            'Catatan',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF243447),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detail.summary,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              height: 1.45,
              color: Color(0xFF5F6C78),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                color: Colors.black45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                color: Color(0xFF243447),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
