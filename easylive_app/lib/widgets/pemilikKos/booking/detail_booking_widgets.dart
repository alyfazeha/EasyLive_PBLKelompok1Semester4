import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/pemilikKos/detail_booking_model.dart';

class DetailBookingTenantHeader extends StatelessWidget {
  final DetailBookingModel booking;

  const DetailBookingTenantHeader({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: const Color(0xFFE8EEF4),
          child: Text(
            booking.tenantName.substring(0, 1),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.tenantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 3),
                _ContactLine(
                  icon: Icons.phone_outlined,
                  text: booking.phone,
                ),
                const SizedBox(height: 2),
                _ContactLine(
                  icon: Icons.email_outlined,
                  text: booking.email,
                ),
              ],
            ),
          ),
        ),
        _StatusBadge(label: booking.bookingStatus),
      ],
    );
  }
}

class DetailBookingInfoCard extends StatelessWidget {
  final DetailBookingModel booking;

  const DetailBookingInfoCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          DetailBookingInfoRow(label: 'Kost', value: booking.kosName),
          const SizedBox(height: 12),
          DetailBookingInfoRow(
            label: 'Tanggal Masuk',
            value: booking.checkInDate,
          ),
          const SizedBox(height: 12),
          DetailBookingInfoRow(
            label: 'Harga / Bulan',
            value: booking.monthlyPrice,
          ),
          const SizedBox(height: 12),
          DetailBookingInfoRow(
            label: 'Status Pembayaran',
            valueWidget: Align(
              alignment: Alignment.centerLeft,
              child: _PaymentBadge(label: booking.paymentStatus),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBookingInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const DetailBookingInfoRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: Color(0xFF637083),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: valueWidget ??
              Text(
                value ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
        ),
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.darkBlue),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

  class _StatusBadge extends StatelessWidget {
    final String label;

    const _StatusBadge({required this.label});

    @override
    Widget build(BuildContext context) {
      Color bgColor;
      Color textColor;

      switch (label.toLowerCase()) {
        case 'aktif':
          bgColor = const Color(0xFFD9F4DF);
          textColor = const Color(0xFF31B75D);
          break;
        case 'pending':
          bgColor = const Color(0xFFFFF3D6);
          textColor = const Color(0xFFFFB200);
          break;
        case 'ditolak':
          bgColor = const Color(0xFFFFEAEA);
          textColor = Colors.red;
          break;
        case 'selesai':
          bgColor = const Color(0xFFEAF1FF);
          textColor = const Color(0xFF4D82FF);
          break;
        default:
          bgColor = Colors.grey.shade200;
          textColor = Colors.grey;
      }

      return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      );
    }
  }

  class _PaymentBadge extends StatelessWidget {
    final String label;

    const _PaymentBadge({required this.label});

    @override
    Widget build(BuildContext context) {
      final isLunas = label.toLowerCase() == 'lunas';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: isLunas
              ? const Color(0xFFD9F4DF)
              : const Color(0xFFFFF3D6),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: isLunas
                ? const Color(0xFF31B75D)
                : const Color(0xFFFFB200),
          ),
        ),
      );
    }
  }
