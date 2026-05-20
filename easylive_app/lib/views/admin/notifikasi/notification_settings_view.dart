import 'package:flutter/material.dart';

import '../../../controllers/admin/notifikasi/notifikasi_settings_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';

class AdminNotificationSettingsView extends StatefulWidget {
  const AdminNotificationSettingsView({super.key});

  @override
  State<AdminNotificationSettingsView> createState() => _AdminNotificationSettingsViewState();
}

class _AdminNotificationSettingsViewState extends State<AdminNotificationSettingsView> {
  final controller = AdminNotificationSettingsController();


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _switchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.golden,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Notification Settings',
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
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _switchRow(
                        title: 'Push Notifications',
                        subtitle: 'Aktifkan notifikasi push untuk admin',
                        value: controller.pushNotif,
                        onChanged: controller.togglePush,
                        icon: Icons.notifications_active,
                      ),
                      _switchRow(
                        title: 'Email Notifications',
                        subtitle: 'Kirim notifikasi melalui email',
                        value: controller.emailNotif,
                        onChanged: controller.toggleEmail,
                        icon: Icons.email_outlined,
                      ),
                      _switchRow(
                        title: 'WhatsApp Notifications',
                        subtitle: 'Kirim notifikasi melalui WhatsApp',
                        value: controller.whatsappNotif,
                        onChanged: controller.toggleWhatsapp,
                        icon: Icons.phone_in_talk,
                      ),
                      _switchRow(
                        title: 'Only Unread',
                        subtitle: 'Tampilkan hanya notifikasi yang belum dibaca',
                        value: controller.onlyUnread,
                        onChanged: controller.toggleOnlyUnread,
                        icon: Icons.markunread_outlined,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.save();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pengaturan notifikasi tersimpan'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF6BE00),
                            foregroundColor: const Color(0xFF243447),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}