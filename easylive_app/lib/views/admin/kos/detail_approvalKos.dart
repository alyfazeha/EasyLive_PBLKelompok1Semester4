// detail_approvalKos.dart
import 'package:flutter/material.dart';
import '../../../models/admin/kos_model.dart';
import '../../../widgets/admin/kos/detail_info.dart';
import '../../../widgets/admin/kos/photo_gallery.dart';
import 'reject_reason_approvalKos_view.dart';

class ApprovalDetailView extends StatelessWidget {
  final ApprovalModel approval;

  const ApprovalDetailView({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 80,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF243B55),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Approval Detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
          ),

          // CONTENT CARD
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PROFILE
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(approval.imageUrl),
                            onBackgroundImageError: (_, __) {},
                            child: approval.imageUrl.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  approval.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Kost Owner',
                                  style: TextStyle(color: Colors.grey),
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
                              color: const Color(0xFFFFF3CD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              approval.status,
                              style: const TextStyle(
                                color: Color(0xFFE0A800),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // BUSINESS DETAILS
                      const Text(
                        'Business Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      DetailInfoRow(
                        label: 'Business Name',
                        value: approval.propertyName,
                      ),
                      const DetailInfoRow(
                        label: 'Phone Number',
                        value: '081234567890',
                      ),
                      const DetailInfoRow(
                        label: 'Email',
                        value: 'owner@example.com',
                      ),
                      const DetailInfoRow(
                        label: 'Address',
                        value: 'Jl. Soekarno Hatta No. 10, Malang',
                      ),
                      const DetailInfoRow(
                        label: 'Description',
                        value: 'Kost nyaman, bersih, dan dekat kampus.',
                      ),

                      const SizedBox(height: 30),

                      // PHOTOS
                      const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tampilkan 3 foto lokal untuk menghindari http request failed.
                      // Sesuaikan dengan nama aset yang tersedia.
                      PhotoGallery(
                        photos: [
                          'assets/images/kamarKos.jpg',
                          'assets/images/kos1.jpg',
                          'assets/images/kos2.jpg',
                        ],
                      ),

                      const SizedBox(height: 30),

                      // BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Buka halaman input alasan reject
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RejectReasonApprovalKosView(
                                      kostId: approval.id,
                                      propertyName: approval.propertyName,
                                    ),
                                  ),
                                ).then((result) {
                                  if (result == 'rejected') {
                                    Navigator.pop(context, 'rejected');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, 'approved');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF4C430),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
