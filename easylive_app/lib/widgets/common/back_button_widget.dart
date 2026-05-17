import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;
  final VoidCallback? onPressed;

  const BackButtonWidget({
    super.key,
    this.backgroundColor = const Color(0xFFF6BE00),
    this.iconColor = const Color(0xFF243447),
    this.size = 44,
    this.iconSize = 20,
    this.borderRadius = 14,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () {
            if (onPressed != null) {
              onPressed!();
              return;
            }
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Fallback: kembali ke halaman root
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
