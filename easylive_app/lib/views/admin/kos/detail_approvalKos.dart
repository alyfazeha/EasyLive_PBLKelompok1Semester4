// detail_approvalKos.dart
import 'package:flutter/material.dart';

import '../../../controllers/admin/approvalKos_detail_controller.dart';
import '../../../models/admin/approvalKos_model.dart';
import '../../../models/admin/kos_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/kos/detail_info.dart';
import '../../../widgets/admin/kos/photo_gallery.dart';
import 'reject_reason_approvalKos_view.dart';

class ApprovalDetailView extends StatefulWidget {
  final ApprovalModel approval;

  const ApprovalDetailView({super.key, required this.approval});

  @override
  State<ApprovalDetailView> createState() => _ApprovalDetailViewState();
}

class _ApprovalDetailViewState extends State<ApprovalDetailView> {
  final ApprovalDetailController controller = ApprovalDetailController();

  ApprovalDetailModel? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => isLoading = true);
    final res = await controller.getApprovalDetail(widget.approval.id);
    if (!mounted) return;
    setState(() {
      detail = res;
      isLoading = false;
    });
  }

  Future<void> _handleApprove() async {
    try {
      await controller.approveKost(widget.approval.id);
      if (!mounted) return;
      await _fetchDetail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kost berhasil di-approve'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal approve: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleReject() async {
    final reason = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => RejectReasonApprovalKosView(
          kostId: widget.approval.id,
          propertyName: widget.approval.propertyName,
        ),
      ),
    );

    if (reason == null || reason.trim().isEmpty) return;

    try {
      await controller.rejectKost(widget.approval.id, reason);
      if (!mounted) return;
      await _fetchDetail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kost berhasil direject'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal reject: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rejectionReason = detail?.rejectionReason?.trim() ?? '';
    final status = (detail?.status ?? widget.approval.status).toLowerCase();

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
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6BE00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF243447),
                    ),
                  ),
                ),
                const Text(
                  'Approval Detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, '/admin/notifikasi'),
                  borderRadius: BorderRadius.circular(18),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // CONTENT CARD
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (detail == null)
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : SingleChildScrollView(
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
                                  backgroundImage: NetworkImage(
                                    detail!.profileImage,
                                  ),
                                  onBackgroundImageError: (_, __) {},
                                  child: detail!.profileImage.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail!.ownerName,
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
                                    detail!.status,
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
                              value: detail!.businessName,
                            ),
                            DetailInfoRow(
                              label: 'Phone Number',
                              value: detail!.phoneNumber,
                            ),
                            DetailInfoRow(label: 'Email', value: detail!.email),
                            DetailInfoRow(
                              label: 'Address',
                              value: detail!.address,
                            ),
                            DetailInfoRow(
                              label: 'Description',
                              value: detail!.description,
                            ),

                            if (status == 'ditolak' ||
                                status == 'rejected') ...[
                              if (rejectionReason.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Rejection Reason',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF2F2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFFD0D0),
                                    ),
                                  ),
                                  child: Text(
                                    rejectionReason,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ],

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

                            (detail!.photos.isNotEmpty)
                                ? PhotoGallery(photos: detail!.photos)
                                : Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F8F8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: const Text(
                                      'Tidak ada gambar untuk kost ini.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 30),

                            // BUTTONS
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: status == 'pending'
                                        ? _handleReject
                                        : null,
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
                                    onPressed: status == 'pending'
                                        ? _handleApprove
                                        : null,
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
      bottomNavigationBar: AdminBottomNavbar(
        selectedIndex: 2,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/admin');
              return;
            case 1:
              Navigator.pushNamed(context, '/admin/history');
              return;
            case 2:
              Navigator.pushNamed(context, '/admin/kos');
              return;
            case 3:
              Navigator.pushNamed(context, '/admin/jasa');
              return;
            case 4:
              Navigator.pushNamed(context, '/admin/profile');
              return;
          }
        },
      ),
    );
  }
}
