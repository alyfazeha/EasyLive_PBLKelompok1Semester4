import 'package:flutter/material.dart';

import '../../../controllers/admin/help_support/help_support_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';

class AdminHelpSupportView extends StatefulWidget {
  const AdminHelpSupportView({super.key});

  @override
  State<AdminHelpSupportView> createState() => _AdminHelpSupportViewState();
}

class _AdminHelpSupportViewState extends State<AdminHelpSupportView> {
  final controller = AdminHelpSupportController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = controller.model;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                BackButtonWidget(
                  backgroundColor: AppColors.golden,
                  iconColor: AppColors.darkBlue,
                  size: 44,
                  iconSize: 20,
                  borderRadius: 12,
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Help & Support',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: AppColors.golden,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _infoCard(
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    value: model.contactEmail,
                  ),
                  const SizedBox(height: 12),
                  _infoCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone Support',
                    value: model.contactPhone,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Panduan cepat',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Untuk masalah akses, hubungi email support\n'
                          '• Untuk kendala transaksi, sertakan detail bukti\n'
                          '• Respon maksimal 1x24 jam kerja',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

