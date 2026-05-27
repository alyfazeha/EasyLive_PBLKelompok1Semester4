import 'package:flutter/material.dart';

import '../../../widgets/admin/dashboard/navbar_button.dart';
import '../../../widgets/admin/kos/detail_info.dart';
import 'reject_reason_jasa_view.dart';

class AdminJasaDetailView extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? submittedDate;
  final String? status;
  final String? imageAsset;
  final String? rejectionReason;

  const AdminJasaDetailView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.submittedDate,
    required this.status,
    required this.imageAsset,
    this.rejectionReason,
  });

  @override
  Widget build(BuildContext context) {
    final serviceType = _safeText(title);
    final businessName = _safeText(subtitle);
    final submittedAt = _safeText(submittedDate);
    final currentStatus = _safeText(status, fallback: 'Pending');
    final imagePath = imageAsset?.trim() ?? '';
    final reason = rejectionReason?.trim() ?? '';
    final statusStyle = _statusStyle(currentStatus);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
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
                      Row(
                        children: [
                          ClipOval(
                            child: _JasaAssetImage(
                              path: imagePath,
                              size: 48,
                              icon: Icons.miscellaneous_services,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  businessName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Jasa Owner',
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
                              color: statusStyle.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentStatus,
                              style: TextStyle(
                                color: statusStyle.foreground,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
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
                        value: businessName,
                      ),
                      DetailInfoRow(label: 'Service Type', value: serviceType),
                      const DetailInfoRow(
                        label: 'Phone Number',
                        value: '081234567890',
                      ),
                      const DetailInfoRow(
                        label: 'Email',
                        value: 'ownerjasa@example.com',
                      ),
                      const DetailInfoRow(
                        label: 'Address',
                        value: 'Jl. Veteran No. 21, Malang',
                      ),
                      DetailInfoRow(
                        label: 'Submitted',
                        value: submittedAt,
                      ),
                      const DetailInfoRow(
                        label: 'Description',
                        value:
                            'Layanan jasa untuk membantu kebutuhan penghuni kos dengan proses pemesanan yang praktis.',
                      ),
                      if (currentStatus.toLowerCase() == 'rejected' &&
                          reason.isNotEmpty) ...[
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
                            reason,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _JasaPhotoGallery(
                        photos: [
                          imagePath,
                          'assets/images/mobilBox-BackgroundRemover.jpg',
                          'assets/images/pickup-removed.png',
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Bottom action buttons (fixed width, no Expanded to avoid ParentDataWidget conflicts)
                      Builder(
                        builder: (context) {
                          final halfWidth =
                              (MediaQuery.of(context).size.width - 40 - 12) /
                                  2; // subtract padding approx + spacing
                          return Row(
                            children: [
                              SizedBox(
                                width: halfWidth,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    final reason =
                                        await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RejectReasonJasaView(
                                          serviceName: businessName,
                                        ),
                                      ),
                                    );

                                    if (reason == null ||
                                        reason.trim().isEmpty) {
                                      return;
                                    }

                                    if (!context.mounted) return;
                                    Navigator.pop(context, {
                                      'status': 'rejected',
                                      'reason': reason,
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
                              SizedBox(
                                width: halfWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, {
                                      'status': 'approved',
                                    });
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
                          );
                        },
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

  _JasaStatusStyle _statusStyle(String status) {
    final value = status.toLowerCase();

    if (value == 'approved') {
      return const _JasaStatusStyle(
        background: Color(0xFFE6F6EC),
        foreground: Color(0xFF31B75D),
      );
    }

    if (value == 'rejected') {
      return const _JasaStatusStyle(
        background: Color(0xFFFFE6E6),
        foreground: Color(0xFFE53935),
      );
    }

    return const _JasaStatusStyle(
      background: Color(0xFFFFF3CD),
      foreground: Color(0xFFE0A800),
    );
  }

  String _safeText(String? value, {String fallback = '-'}) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }
}

class _JasaPhotoGallery extends StatelessWidget {
  final List<String> photos;

  const _JasaPhotoGallery({
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    final visiblePhotos =
        photos.where((photo) => photo.trim().isNotEmpty).toList();

    if (visiblePhotos.isEmpty) {
      return const Text(
        'No photos available',
        style: TextStyle(color: Colors.grey),
      );
    }

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: visiblePhotos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _JasaAssetImage(
              path: visiblePhotos[index],
              size: 70,
              icon: Icons.image_not_supported_outlined,
            ),
          );
        },
      ),
    );
  }
}

class _JasaAssetImage extends StatelessWidget {
  final String path;
  final double size;
  final IconData icon;

  const _JasaAssetImage({
    required this.path,
    required this.size,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (path.trim().isEmpty) {
      return _placeholder();
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFFEAF0F7),
      child: Icon(
        icon,
        color: const Color(0xFF243447),
        size: size <= 48 ? 22 : 26,
      ),
    );
  }
}

class _JasaStatusStyle {
  final Color background;
  final Color foreground;

  const _JasaStatusStyle({
    required this.background,
    required this.foreground,
  });
}

