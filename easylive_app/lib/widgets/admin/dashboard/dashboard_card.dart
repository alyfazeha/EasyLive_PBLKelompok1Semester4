import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the card's real width (works better than screen width inside grid).
        final cardWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        // Height juga ikut dipertimbangkan supaya tidak overflow ketika card jadi terlalu pendek.
        final cardHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : 0.0;

        // Clamp khusus HP supaya tetap readable saat card terlalu sempit/pendek.
        final isPhone = cardWidth <= 170;

        final widthScale = cardWidth / 180;
        final heightScale = cardHeight > 0 ? cardHeight / 150 : 1.0;

        // Ambil skala konservatif (yang paling membatasi).
        final baseScale = isPhone ? widthScale : widthScale;
        final scale = (cardHeight > 0)
            ? (baseScale < heightScale ? baseScale : heightScale)
            : baseScale;

        final clampedScale = isPhone
            ? scale.clamp(0.70, 1.00)
            : scale.clamp(0.82, 1.15);

        final padding = (13 * clampedScale).roundToDouble().clamp(
          isPhone ? 7.0 : 10.0,
          isPhone ? 12.0 : 14.0,
        );
        final borderRadius = (14 * clampedScale).roundToDouble().clamp(
          isPhone ? 10.0 : 12.0,
          isPhone ? 15.0 : 16.0,
        );
        final iconRadius = (16 * clampedScale).roundToDouble().clamp(
          isPhone ? 11.0 : 13.0,
          isPhone ? 17.0 : 18.0,
        );
        final iconSize = (18 * clampedScale).roundToDouble().clamp(
          isPhone ? 13.0 : 15.0,
          isPhone ? 21.0 : 22.0,
        );
        final chevronSize = (18 * clampedScale).roundToDouble().clamp(
          isPhone ? 12.0 : 14.0,
          isPhone ? 19.0 : 20.0,
        );

        final valueFontSize = (25 * clampedScale).roundToDouble().clamp(
          isPhone ? 16.0 : 18.0,
          isPhone ? 25.0 : 28.0,
        );
        final titleFontSize = (11 * clampedScale).roundToDouble().clamp(
          isPhone ? 8.0 : 9.0,
          isPhone ? 12.5 : 13.0,
        );
        final captionFontSize = (9 * clampedScale).roundToDouble().clamp(
          isPhone ? 6.8 : 7.5,
          isPhone ? 10.0 : 11.0,
        );

        // Kurangi spacing khusus HP supaya tinggi total tidak meledak.
        final gapTop = (10 * clampedScale).roundToDouble().clamp(
          isPhone ? 6.0 : 8.0,
          isPhone ? 10.0 : 12.0,
        );
        final gapMid = (3 * clampedScale).roundToDouble().clamp(
          isPhone ? 1.4 : 2.0,
          isPhone ? 3.2 : 4.0,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: const Color(0xFFE8EEF5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10 * clampedScale,
                      offset: Offset(0, 4 * clampedScale),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: iconRadius,
                          backgroundColor: iconColor.withOpacity(0.15),
                          child: Icon(icon, color: iconColor, size: iconSize),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: chevronSize,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    SizedBox(height: gapTop),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF243447),
                      ),
                    ),
                    SizedBox(height: gapMid),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: gapMid),
                    Text(
                      caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: captionFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
