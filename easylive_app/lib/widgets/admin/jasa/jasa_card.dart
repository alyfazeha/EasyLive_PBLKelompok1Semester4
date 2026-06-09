import 'package:flutter/material.dart';

class JasaCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? submittedDate;
  final String? status;
  final String? imageAsset;
  final VoidCallback onTap;

  const JasaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.submittedDate,
    required this.status,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final serviceType = _safeText(title);
    final businessName = _safeText(subtitle);
    final submittedAt = _safeText(submittedDate);
    final currentStatus = _safeText(status, fallback: 'Pending');
    final imagePath = imageAsset?.trim() ?? '';
    final statusStyle = _statusStyle(currentStatus);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: _JasaCardImage(path: imagePath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Submitted $submittedAt',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusStyle.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentStatus,
                style: TextStyle(
                  fontSize: 11,
                  color: statusStyle.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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

class _JasaCardImage extends StatelessWidget {
  final String path;

  const _JasaCardImage({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path.trim().isEmpty) {
      return _placeholder();
    }

    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        path,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return Image.asset(
      path,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFEAF0F7),
      child: const Icon(
        Icons.person,
        color: Color(0xFF243447),
        size: 22,
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

