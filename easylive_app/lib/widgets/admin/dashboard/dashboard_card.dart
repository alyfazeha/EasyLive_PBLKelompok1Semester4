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

        // Clamp khusus HP supaya tetap readable saat card terlalu sempit.
        final isPhone = cardWidth <= 170;

        final baseScale = cardWidth / 180;
        final scale = isPhone
            ? baseScale.clamp(0.78, 1.00)
            : baseScale.clamp(0.85, 1.15);

        final padding = (13 * scale).roundToDouble().clamp(
          isPhone ? 9.0 : 10.0,
          isPhone ? 12.0 : 14.0,
        );
        final borderRadius = (14 * scale).roundToDouble().clamp(
          isPhone ? 11.0 : 12.0,
          isPhone ? 15.0 : 16.0,
        );
        final iconRadius = (16 * scale).roundToDouble().clamp(
          isPhone ? 12.0 : 13.0,
          isPhone ? 17.0 : 18.0,
        );
        final iconSize = (18 * scale).roundToDouble().clamp(
          isPhone ? 14.0 : 15.0,
          isPhone ? 21.0 : 22.0,
        );
        final chevronSize = (18 * scale).roundToDouble().clamp(
          isPhone ? 13.0 : 14.0,
          isPhone ? 19.0 : 20.0,
        );

        final valueFontSize = (25 * scale).roundToDouble().clamp(
          isPhone ? 17.0 : 18.0,
          isPhone ? 25.0 : 28.0,
        );
        final titleFontSize = (11 * scale).roundToDouble().clamp(
          isPhone ? 8.5 : 9.0,
          isPhone ? 12.5 : 13.0,
        );
        final captionFontSize = (9 * scale).roundToDouble().clamp(
          isPhone ? 7.0 : 7.5,
          isPhone ? 10.0 : 11.0,
        );

        final gapTop = (10 * scale).roundToDouble().clamp(
          isPhone ? 7.0 : 8.0,
          isPhone ? 11.0 : 12.0,
        );
        final gapMid = (3 * scale).roundToDouble().clamp(
          isPhone ? 1.8 : 2.0,
          isPhone ? 3.6 : 4.0,
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
                      blurRadius: 10 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, inner) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: iconRadius,
                              backgroundColor: iconColor.withOpacity(0.15),
                              child: Icon(
                                icon,
                                color: iconColor,
                                size: iconSize,
                              ),
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
                          style: TextStyle(
                            fontSize: captionFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
