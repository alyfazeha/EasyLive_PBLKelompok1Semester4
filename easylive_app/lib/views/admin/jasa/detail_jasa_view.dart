// views/admin/jasa/detail_jasa_view.dart

import 'package:flutter/material.dart';

import '../../../controllers/admin/approval_jasa_controller.dart';
import '../../../models/admin/approval_jasa_model.dart';
import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/kos/detail_info.dart';
import '../../../widgets/admin/kos/photo_gallery.dart';
import 'reject_reason_jasa_view.dart';

class AdminJasaDetailView extends StatefulWidget {
  final String idJasa;

  const AdminJasaDetailView({
    super.key,
    required this.idJasa,
  });

  @override
  State<AdminJasaDetailView> createState() => _AdminJasaDetailViewState();
}

class _AdminJasaDetailViewState extends State<AdminJasaDetailView> {
  final ApprovalJasaController _controller = ApprovalJasaController();

  ApprovalJasaModel? _detail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    final result = await _controller.getJasaDetail(widget.idJasa);
    if (!mounted) return;
    setState(() {
      _detail = result;
      _isLoading = false;
    });
  }

  // ─── APPROVE ───────────────────────────────────────────────────────────────

  Future<void> _handleApprove() async {
    try {
      await _controller.approveJasa(widget.idJasa);
      if (!mounted) return;
      await _fetchDetail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jasa berhasil di-approve'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, {'status': 'approved'});
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

  // ─── REJECT ────────────────────────────────────────────────────────────────

  Future<void> _handleReject() async {
    final reason = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => RejectReasonJasaView(
          serviceName: _detail?.namaJasa ?? '',
        ),
      ),
    );

    if (reason == null || reason.trim().isEmpty) return;

    try {
      await _controller.rejectJasa(widget.idJasa, reason);
      if (!mounted) return;
      await _fetchDetail();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jasa berhasil direject'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context, {'status': 'rejected', 'reason': reason});
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

  // ─── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final status = _detail?.status.toLowerCase() ?? '';
    final rejectionReason = _detail?.rejectionReason?.trim() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────────
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
                  'Jasa Detail',
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

          // ── CONTENT ─────────────────────────────────────────────────────────
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF243B55),
                      ),
                    )
                  : _detail == null
                      ? const Center(
                          child: Text('Data tidak ditemukan'),
                        )
                      : SingleChildScrollView(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
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
                                // ── PROFILE ROW ───────────────────────────────
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                        _detail!.ownerProfileImage,
                                      ),
                                      onBackgroundImageError: (_, __) {},
                                      child:
                                          _detail!.ownerProfileImage.isEmpty
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
                                            _detail!.ownerName,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Jasa Owner',
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _StatusBadge(status: _detail!.status),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // ── BUSINESS DETAILS ─────────────────────────
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
                                  value: _detail!.namaJasa,
                                ),
                                DetailInfoRow(
                                  label: 'Phone Number',
                                  value: _detail!.nomorHp ?? '-',
                                ),
                                DetailInfoRow(
                                  label: 'Email',
                                  value: _detail!.ownerEmail,
                                ),
                                DetailInfoRow(
                                  label: 'Address',
                                  value: _detail!.fullAddress,
                                ),
                                if (_detail!.tipeMobil != null)
                                  DetailInfoRow(
                                    label: 'Tipe Mobil',
                                    value: _detail!.tipeMobil!,
                                  ),
                                if (_detail!.nomorPlat != null)
                                  DetailInfoRow(
                                    label: 'Nomor Plat',
                                    value: _detail!.nomorPlat!,
                                  ),
                                if (_detail!.kapasitas != null)
                                  DetailInfoRow(
                                    label: 'Kapasitas per kg',
                                    value: _detail!.kapasitas!,
                                  ),
                                DetailInfoRow(
                                  label: 'Description',
                                  value: _detail!.deskripsi ?? '-',
                                ),

                                // ── REJECTION REASON ─────────────────────────
                                if ((status == 'ditolak' ||
                                        status == 'rejected') &&
                                    rejectionReason.isNotEmpty) ...[
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
                                      borderRadius:
                                          BorderRadius.circular(12),
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

                                const SizedBox(height: 30),

                                // ── PHOTOS ───────────────────────────────────
                                const Text(
                                  'Photos',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                _detail!.gambar.isNotEmpty
                                    ? PhotoGallery(
                                        photos: _detail!.gambar,
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color:
                                              const Color(0xFFF8F8F8),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: const Text(
                                          'Tidak ada gambar untuk jasa ini.',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),

                                const SizedBox(height: 30),

                                // ── ACTION BUTTONS ───────────────────────────
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: status == 'pending'
                                            ? _handleReject
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.red),
                                          foregroundColor: Colors.red,
                                          minimumSize:
                                              const Size(0, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    12),
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
                                          backgroundColor:
                                              const Color(0xFFF4C430),
                                          foregroundColor:
                                              Colors.black87,
                                          elevation: 0,
                                          minimumSize:
                                              const Size(0, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    12),
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
        selectedIndex: 3,
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

// ─── STATUS BADGE ────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(status.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _labelFor(status.toLowerCase()),
        style: TextStyle(
          color: style.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _labelFor(String status) {
    switch (status) {
      case 'aktif':
        return 'Approved';
      case 'ditolak':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  ({Color background, Color foreground}) _styleFor(String status) {
    switch (status) {
      case 'aktif':
        return (
          background: const Color(0xFFE6F6EC),
          foreground: const Color(0xFF31B75D),
        );
      case 'ditolak':
        return (
          background: const Color(0xFFFFE6E6),
          foreground: const Color(0xFFE53935),
        );
      default:
        return (
          background: const Color(0xFFFFF3CD),
          foreground: const Color(0xFFE0A800),
        );
    }
  }
}