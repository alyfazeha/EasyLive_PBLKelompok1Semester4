import 'package:flutter/material.dart';

import '../../../controllers/admin/app_settings/app_settings_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';

class AdminAppSettingsView extends StatefulWidget {
  const AdminAppSettingsView({super.key});

  @override
  State<AdminAppSettingsView> createState() => _AdminAppSettingsViewState();
}

class _AdminAppSettingsViewState extends State<AdminAppSettingsView> {
  final controller = AdminAppSettingsController();

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
                    'App Settings',
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
                        title: 'Dark Mode',
                        subtitle: 'Aktifkan tampilan gelap',
                        value: controller.settings.darkMode,
                        onChanged: controller.setDarkMode,
                        icon: Icons.dark_mode_outlined,
                      ),
                      _switchRow(
                        title: 'Reduce Animations',
                        subtitle: 'Kurangi animasi di aplikasi',
                        value: controller.settings.reduceAnimations,
                        onChanged: controller.setReduceAnimations,
                        icon: Icons.animation_outlined,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isSaving
                              ? null
                              : () async {
                                  await controller.save();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('App Settings tersimpan'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.golden,
                            foregroundColor: AppColors.darkBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: controller.isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
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

