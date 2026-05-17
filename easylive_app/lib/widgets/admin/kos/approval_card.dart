// ============================
// approval_card.dart
// ============================

import 'package:flutter/material.dart';
import '../../../models/admin/kos_model.dart';

class _StatusStyle {
  final Color background;
  final Color foreground;

  const _StatusStyle({required this.background, required this.foreground});
}

class ApprovalCard extends StatelessWidget {
  _StatusStyle _statusStyle(String status) {
    final value = status.toLowerCase();

    if (value == 'approved') {
      return const _StatusStyle(
        background: Color(0xFFE6F6EC),
        foreground: Color(0xFF31B75D),
      );
    }

    if (value == 'rejected') {
      return const _StatusStyle(
        background: Color(0xFFFFE6E6),
        foreground: Color(0xFFE53935),
      );
    }

    return const _StatusStyle(
      background: Color(0xFFFFF3CD),
      foreground: Color(0xFFE0A800),
    );
  }

  final ApprovalModel approval;

  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback? onTap;

  // Gunakan nama yang sama dengan yang dipanggil di ApprovalView:
  // showActionButtons (tanpa huruf "s" setelah Action)
  final bool showActionButtons;

  const ApprovalCard({
    super.key,
    required this.approval,
    required this.onApprove,
    required this.onReject,
    this.onTap,
    this.showActionButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        // Samakan tinggi card dengan JasaCard (tidak dibuat fixed/minHeight agar konten menentukan tinggi)
        constraints: const BoxConstraints(minHeight: 0),
        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ================= CONTENT =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(approval.imageUrl),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        approval.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        approval.propertyName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Submitted ${approval.submittedDate}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusStyle(approval.status).background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    approval.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: _statusStyle(approval.status).foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // ================= ACTION BUTTONS =================
            if (showActionButtons) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Trigger reject hanya untuk tombol di Approvals list.
                      // Detail reject (input alasan) ditangani di halaman detail.
                      onReject();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      minimumSize: const Size(90, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4C430),
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(90, 36),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
